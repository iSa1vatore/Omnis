import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:common/utils/date_time_utils.dart';
import 'package:common/utils/encryption_utils.dart';
import 'package:crypton/crypton.dart';
import 'package:data/mapper/attachment_mapper.dart';
import 'package:data/mapper/user_mapper.dart';
import 'package:data/sources/remote/dto/attachment_dto.dart';
import 'package:data/sources/remote/dto/user_dto.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/model/message_attachment/message_attachment.dart';
import 'package:domain/model/public_connection.dart';
import 'package:domain/repository/connections_repository.dart';
import 'package:domain/repository/conversations_repository.dart';
import 'package:domain/repository/messages_repository.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:server/extensions/shelf_request_extension.dart';
import 'package:services/files_cache_service/files_cache_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_multipart/form_data.dart';
import 'package:shelf_multipart/multipart.dart';
import 'package:shelf_router/shelf_router.dart';

import 'enum/server_event_type.dart';
import 'errors.dart';
import 'models/api_response.dart';
import 'models/events/new_message.dart';
import 'models/events/set_messages_activity.dart';
import 'models/server_event.dart';

@Singleton()
class NewServer {
  NewServer(
    this.connectionsRepository,
    this.messagesRepository,
    this.usersRepository,
    this.conversationsRepository,
    this.filesCacheService,
  );

  final ConnectionsRepository connectionsRepository;
  final MessagesRepository messagesRepository;
  final UsersRepository usersRepository;
  final ConversationsRepository conversationsRepository;
  final FilesCacheService filesCacheService;

  late RSAPrivateKey rsaPrivateKey;

  final events = StreamController<ServerEvent>.broadcast();

  Future<void> start({
    required String address,
    required int port,
    required RSAPrivateKey rsaPrivateKey,
  }) async {
    this.rsaPrivateKey = rsaPrivateKey;

    final router = Router()
      ..get("/api/user/get", _apiUserGet)
      ..post("/api/messages/send", _apiMessagesSend)
      ..post("/api/messages/setActivity", _apiMessagesSetActivity)
      ..post("/api/user/connect", _apiUserConnect)
      ..post("/api/files/upload", _apiFilesUpload);

    final handler = const Pipeline().addHandler(router);

    await serve(handler, address, port);
  }

  Future<Response> _apiFilesUpload(Request req) async {
    if (!req.isMultipart) return APIResponse.error(ServerErrors.badRequest);

    var fileDetails = jsonDecode(req.headers["file_details"]!);

    var fileId = fileDetails["id"];
    var fileType = fileDetails["type"];
    var fileName = fileDetails["name"];

    bool fileIsSaved = false;
    var tmpDir = await filesCacheService.tmpDir;

    await for (final formData in req.multipartFormData) {
      var chunks = await formData.part.toList();

      if (fileType == "voice" && formData.name == "voice_file") {
        var voiceFile = File("$tmpDir/$fileId.m4a");

        for (final chunk in chunks) {
          await voiceFile.writeAsBytes(chunk, mode: FileMode.append);
        }

        filesCacheService.saveVoiceMessage(
          file: voiceFile,
          fileId: fileId,
          fileName: fileName,
        );

        fileIsSaved = true;
        break;
      }

      if (fileType == "photo" && formData.name == "photo_file") {
        fileIsSaved = true;
        break;
      }
    }

    if (!fileIsSaved) return APIResponse.error(ServerErrors.badRequest);

    return APIResponse.success(1);
  }

  Future<Response> _apiUserConnect(Request req) async {
    var body = await getBody(req);
    var token = body["token"];
    var sender = req.sender;

    var needCreateConnection = true;

    var findConnection = await connectionsRepository.findByToken(token);

    //Если соединение есть - обновляем данные, если нужно
    var updateError = await findConnection.fold(
      (error) => null,
      (connection) async {
        needCreateConnection = false;

        if (connection.address != sender.address) {
          var updateConnection = await connectionsRepository.update(
            connection.copyWith(address: sender.address),
          );

          return updateConnection.fold((l) => l, (r) => null);
        }

        return null;
      },
    );

    if (updateError != null) {
      return APIResponse.error(ServerErrors.serverError);
    }

    if (!needCreateConnection) {
      return APIResponse.success(1);
    }

    var remoteUser = await usersRepository
        .fetchFromRemote(PublicConnection(
          address: sender.address,
        ))
        .then((user) => user.fold((e) => null, (user) => user));

    if (remoteUser == null) {
      return APIResponse.error(ServerErrors.serverError);
    }

    var localUserId = await usersRepository
        .findByGlobalId(
          remoteUser.globalId,
        )
        .then(
          (localUser) => localUser.fold((error) => null, (user) => user.id),
        );

    localUserId ??= await usersRepository.create(remoteUser).then(
          (localUser) => localUser.fold(
            (error) => null,
            (user) => user.id,
          ),
        );

    if (localUserId == null) {
      return APIResponse.error(ServerErrors.serverError);
    }

    var createConnection = await connectionsRepository.create(Connection(
      userId: localUserId,
      token: token,
      address: sender.address,
      encryptionPublicKey: remoteUser.encryptionPublicKey!,
    ));

    if (createConnection.isRight()) {
      return APIResponse.success(1);
    }

    return APIResponse.error(ServerErrors.serverError);
  }

  Future<Response> _apiMessagesSetActivity(Request req) async {
    var body = await getBody(req);

    var type = body["type"];
    var userId = body["user_id"];

    events.sink.add(ServerEvent(
      type: ServerEventType.setMessagesActivity,
      data: SESetMessagesActivity(
        type: type,
        peerId: userId,
        time: DateTimeUtils.currentTimestamp,
      ),
    ));

    return APIResponse.success(1);
  }

  Future<Response> _apiUserGet(Request req) async {
    var profile = await usersRepository
        .me()
        .then((user) => user.fold((e) => null, (u) => u));

    if (profile != null) {
      UserDto? user = profile.toUserDto(
        rsaPrivateKey.publicKey.toString(),
        isClosed: false,
      );

      return APIResponse.success(user.toJson());
    }

    return APIResponse.error(ServerErrors.serverError);
  }

  Future<Response> _apiMessagesSend(Request req) async {
    var body = await getBody(req);

    var text = body["text"];
    var globalId = body["globalId"];
    var userId = body["user_id"];

    List<MessageAttachment>? attachments;

    if (body["attachments"] != null) {
      List<dynamic> attachmentsList = body["attachments"];

      attachments = attachmentsList
          .map((e) => MessageAttachmentDto.fromJson(e).toAttachment())
          .toList();
    }

    var message = await messagesRepository.add(
      globalId: globalId,
      text: text,
      peerId: userId,
      fromId: userId,
      attachments: attachments,
    );

    events.sink.add(ServerEvent(
      type: ServerEventType.newMessage,
      data: SENewMessage(
        id: message.id,
        globalId: message.globalId,
        time: message.time,
        peerId: message.peerId,
        fromId: message.peerId,
        sendState: message.sendState,
        text: message.text,
        attachments: attachments,
      ),
    ));

    conversationsRepository.update(
      id: message.peerId,
      lastMessageId: message.id,
    );

    return APIResponse.success(1);
  }

  Future<Map<String, dynamic>> getBody(Request req) async {
    var body = await req.body;

    Map<String, dynamic> encodedBody = {};
    if (req.encryption == 'rsa') {
      encodedBody = jsonDecode(EncryptionUtils.rsaDecrypt(
        rsaPrivateKey,
        body,
      ));
    } else if (req.encryption == 'aes') {
      var bodyParts = body.split("\n");

      var connection = await connectionsRepository.findByAddress(
        ip: req.sender.address.ip,
        port: req.sender.address.port,
      );

      if (connection != null) {
        encodedBody = jsonDecode(EncryptionUtils.aesDecrypt(
          key: connection.token,
          ivKey: bodyParts.first,
          message: bodyParts.last,
        ));

        encodedBody["user_id"] = connection.userId;
      } else {
        encodedBody = {};
      }
    }

    return encodedBody;
  }
}

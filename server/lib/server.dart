import 'dart:convert';

import 'package:common/utils/date_time_utils.dart';
import 'package:common/utils/encryption_utils.dart';
import 'package:crypton/crypton.dart';
import 'package:data/mapper/user_mapper.dart';
import 'package:data/repository/settings_repository_impl.dart';
import 'package:data/sources/remote/api_service.dart';
import 'package:data/sources/remote/dto/user_dto.dart';
import 'package:domain/enum/message_activity.dart';
import 'package:domain/model/api_error.dart';
import 'package:domain/model/message_activity.dart';
import 'package:domain/model/network_address.dart';
import 'package:domain/model/user_connection.dart';
import 'package:domain/repository/connections_repository.dart';
import 'package:domain/repository/conversations_repository.dart';
import 'package:domain/repository/messages_repository.dart';
import 'package:domain/repository/private_keys_repository.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:server/errors.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

@Singleton()
class Server {
  final ApiService apiService;

  final UsersRepository usersRepository;
  final SettingsRepository settingsRepository;
  final PrivateKeysRepository privateKeysRepository;
  final ConnectionsRepository connectionsRepository;
  final MessagesRepository messagesRepository;
  final ConversationsRepository conversationsRepository;

  late RSAPrivateKey rsaPrivateKey;

  Server(
    this.apiService,
    this.usersRepository,
    this.settingsRepository,
    this.privateKeysRepository,
    this.connectionsRepository,
    this.messagesRepository,
    this.conversationsRepository,
  );

  start({required String address, required int port}) async {
    var stringKey = await privateKeysRepository.fetchEncryptionPrivateKey();

    rsaPrivateKey = EncryptionUtils.rsaPrivateKeyFromString(stringKey!);

    final router = Router()
      ..get("/api/user/get", _apiUserGet)
      ..post("/api/user/connect", _apiUserConnect)
      ..get("/api/contacts/add", _apiUContactsAdd)
      ..post("/api/messages/send", _apiMessagesSend)
      ..post("/api/messages/setActivity", _apiMessagesSetActivity)
      ..post("/api/files/upload", _apiFilesUpload);

    final handler = const Pipeline().addHandler(router);

    await serve(handler, address, port);
  }

  Future<Response> _apiFilesUpload(Request req) async {
    return Api.response(1);
  }

  Future<Response> _apiUserGet(Request req) async {
    if (!settingsRepository.privacyShowInPeopleNearby) {
      return Api.error(ServerErrors.accessDenied);
    }

    var profile = await usersRepository.me();

    if (profile.data != null) {
      var user = profile.data!;

      return Api.response(
        UserDto(
          globalId: user.globalId,
          name: user.name,
          photo: user.photo,
          isClosed: settingsRepository.privacyClosedMessages,
          encryptionPublicKey: rsaPrivateKey.publicKey.toString(),
        ).toJson(),
      );
    }

    return Api.error(ServerErrors.accessDenied);
  }

  Future<Response> _apiUserConnect(Request req) async {
    if (settingsRepository.privacyClosedMessages) {
      return Api.error(ServerErrors.accessDenied);
    }

    var body = await getBody(req);
    var sender = req.sender;

    var address = sender.split(":");

    var userInfo = await apiService.fetchUser(UserConnection(
      address: NetworkAddress(address[0], int.parse(address[1])),
      token: body["token"],
      encryptionPublicKey: "",
    ));

    var newUser = await usersRepository.create(userInfo.toUser());

    if (newUser.data == null) {
      return Api.error(ServerErrors.connectionError);
    }

    connectionsRepository.createConnection(
      userId: newUser.data!.id,
      userConnection: UserConnection(
        address: NetworkAddress(address[0], int.parse(address[1])),
        token: body["token"],
        encryptionPublicKey: userInfo.encryptionPublicKey,
      ),
    );

    return Api.response(1);
  }

  Response _apiUContactsAdd(Request req) {
    return Api.response(1);
  }

  Future<Response> _apiMessagesSend(Request req) async {
    var body = await getBody(req);

    var text = body["text"];
    var globalId = body["globalId"];
    var userId = body["user_id"];

    var findUser = await usersRepository.findByID(userId);

    findUser.result(
      onSuccess: (u) async {
        var messageId = await messagesRepository.add(
          globalId: globalId,
          text: text,
          peerId: u.id,
          fromId: u.id,
        );

        messageId.result(
          onSuccess: (lastMessageId) {
            conversationsRepository.update(
              id: u.id,
              lastMessageId: lastMessageId,
            );
          },
          onError: (e) {},
        );
      },
      onError: (e) {},
    );

    return Api.response(1);
  }

  Future<Response> _apiMessagesSetActivity(Request req) async {
    var body = await getBody(req);

    var type = body["type"];
    var userId = body["user_id"];

    MessageActivityType activityType;

    if (type == "audiomessage") {
      activityType = MessageActivityType.audiomessage;
    } else {
      activityType = MessageActivityType.typing;
    }

    messagesRepository.setActivity(MessageActivity(
      peerId: userId,
      type: activityType,
      time: DateTimeUtils.currentTimestamp,
    ));

    return Api.response(1);
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

      var sender = req.sender.split(":");

      var connection = await connectionsRepository.findByAddress(
        ip: sender.first,
        port: int.parse(sender.last),
      );

      connection.result(
        onSuccess: (r) {
          encodedBody = jsonDecode(EncryptionUtils.aesDecrypt(
            key: r.token,
            ivKey: bodyParts.first,
            message: bodyParts.last,
          ));

          encodedBody["user_id"] = r.userId;
        },
        onError: (r) {
          encodedBody = {};
        },
      );
    }

    return encodedBody;
  }
}

extension ShelfRequestExtension on Request {
  String get sender => headers["sender"]!;

  String get encryption => headers["encryption"]!;

  Future<String> get body => readAsString();
}

class Api {
  static response(dynamic data) {
    return Response.ok(
      json.encode({"response": data}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static error(APIError apiError) {
    return Response.ok(
      json.encode({
        "error": {"code": apiError.code, "message": apiError.message},
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

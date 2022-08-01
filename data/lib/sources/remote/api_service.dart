import 'dart:convert';

import 'package:common/utils/encryption_utils.dart';
import 'package:data/sources/remote/dto/user_dto.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:domain/enum/message_activity.dart';
import 'package:domain/exceptions/api_failure.dart';
import 'package:domain/model/connection.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class ApiService {
  final Dio dio;

  late String sender;

  ApiService(this.dio) {
    if (true) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) => "PROXY 192.168.1.39:8888;";
        return null;
      };
    }
  }

  setSender({
    required String address,
    required int port,
    required String userGlobalId,
  }) {
    sender = "$address:$port:$userGlobalId";
  }

  Future<int> uploadFile(
    Connection connection, {
    required String fileId,
    required String filePath,
    required String fileName,
    required String fileType,
  }) async {
    var formData = FormData.fromMap({
      "${fileType}_file": await MultipartFile.fromFile(filePath),
    });

    var response = await _call(
      connection,
      method: "/files/upload",
      formData: formData,
      encryption: Encryption.none,
      headers: {
        "file_details": jsonEncode({
          "id": fileId,
          "type": fileType,
          "name": fileName,
        })
      },
    );

    return response.data;
  }

  Future<int> messagesSetActivity(
    Connection connection, {
    required MessageActivityType type,
  }) async {
    var activityType =
        type == MessageActivityType.typing ? "typing" : "audiomessage";

    var response = await _call(
      connection,
      method: "/messages/setActivity",
      data: {"type": activityType},
    );

    return response.data;
  }

  Future<UserDto> fetchUser(Connection connection) async {
    var response = await _call(
      connection,
      method: "/user/get",
      encryption: Encryption.none,
    );

    return UserDto.fromJson(response.data);
  }

  Future<int> messagesSend(
    Connection connection, {
    String? text,
    List<Map<String, dynamic>>? attachments,
    required String globalId,
  }) async {
    var response = await _call(
      connection,
      method: "/messages/send",
      data: {
        "text": text,
        "globalId": globalId,
        "attachments": attachments,
      },
    );

    return response.data;
  }

  Future<int> connectToUser(Connection connection) async {
    var response = await _call(
      connection,
      method: "/user/connect",
      data: {"token": connection.token},
      encryption: Encryption.rsa,
    );

    return response.data;
  }

  Future<Response> _call(
    Connection connection, {
    required String method,
    Encryption encryption = Encryption.aes,
    Map<String, dynamic>? data,
    Map<String, dynamic> headers = const {},
    FormData? formData,
  }) async {
    var address = connection.address;

    var path = "http://${address.ip}:${address.port}/api$method";

    Response<dynamic> response;

    if (data != null || formData != null) {
      dynamic serializedData;

      if (data != null) {
        if (encryption == Encryption.rsa) {
          var rsaPublicKey = EncryptionUtils.rsaPublicKeyFromString(
            connection.encryptionPublicKey,
          );

          serializedData = EncryptionUtils.rsaEncrypt(
            rsaPublicKey,
            jsonEncode(data),
          );
        } else if (encryption == Encryption.aes) {
          serializedData = EncryptionUtils.aesEncrypt(
            connection.token,
            jsonEncode(data),
          );
        } else {
          serializedData = jsonEncode(data);
        }
      } else {
        serializedData = formData;
      }

      response = await dio.post(
        path,
        data: serializedData,
        options: Options(
          headers: {
            ...{
              "encryption": encryption.toString().split(".").last,
              "sender": sender,
            },
            ...headers
          },
        ),
      );
    } else {
      response = await dio.get(path);
    }

    if (response.data is Map) {
      if (response.data.containsKey("response")) {
        response.data = response.data["response"];
      } else if (response.data.containsKey("error")) {
        var error = response.data["error"];

        throw ApiFailure(
          code: error["code"],
          message: error["message"],
        );
      }
    }

    return response;
  }
}

enum Encryption { none, rsa, aes }

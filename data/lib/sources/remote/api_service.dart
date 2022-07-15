import 'dart:convert';

import 'package:common/utils/encryption_utils.dart';
import 'package:data/sources/remote/dto/user_dto.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:domain/enum/message_activity.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/model/user_connection.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class ApiService {
  final Dio dio;

  late String sender;

  ApiService(this.dio) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) => "PROXY 192.168.1.39:8888;";
      return null;
    };
  }

  setSender({required String address, required int port}) {
    sender = "$address:$port";
  }

  Future<int> messagesSetActivity(
    Connection connection, {
    required MessageActivityType type,
  }) async {
    var activityType =
        type == MessageActivityType.typing ? "typing" : "audiomessage";

    var response = await _callNew(
      connection,
      method: "/messages/setActivity",
      data: {"type": activityType},
    );

    return response.data;
  }

  Future<int> messagesSend(
    Connection connection, {
    required String text,
    required String globalId,
  }) async {
    var response = await _callNew(
      connection,
      method: "/messages/send",
      data: {
        "text": text,
        "globalId": globalId,
      },
    );

    return response.data;
  }

  Future<int> connectToUser(UserConnection userConnection) async {
    var response = await _call(
      userConnection,
      method: "/user/connect",
      data: {"token": userConnection.token},
      encryption: Encryption.rsa,
    );

    return response.data;
  }

  Future<UserDto> fetchUser(UserConnection userConnection) async {
    var response = await _call(
      userConnection,
      method: "/user/get",
      encryption: Encryption.none,
    );

    return UserDto.fromJson(response.data);
  }

  Future<Response> _call(
    UserConnection userConnection, {
    required String method,
    Encryption encryption = Encryption.aes,
    Map<String, dynamic>? data,
  }) async {
    var address = userConnection.address;

    var path = "http://${address.ip}:${address.port}/api$method";

    if (data != null) {
      String serializedData;

      if (encryption == Encryption.rsa) {
        var rsaPublicKey = EncryptionUtils.rsaPublicKeyFromString(
          userConnection.encryptionPublicKey,
        );

        serializedData = EncryptionUtils.rsaEncrypt(
          rsaPublicKey,
          jsonEncode(data),
        );
      } else if (encryption == Encryption.aes) {
        serializedData = EncryptionUtils.aesEncrypt(
          userConnection.token,
          jsonEncode(data),
        );
      } else {
        serializedData = jsonEncode(data);
      }

      return dio.post(
        path,
        data: serializedData,
        options: Options(
          headers: {
            "encryption": encryption.toString().split(".").last,
            "sender": sender,
          },
        ),
      );
    }

    return dio.get(path);
  }

  Future<Response> _callNew(
    Connection connection, {
    required String method,
    Encryption encryption = Encryption.aes,
    Map<String, dynamic>? data,
  }) async {
    var address = connection.address;

    var path = "http://${address.ip}:${address.port}/api$method";

    if (data != null) {
      String serializedData;

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

      return dio.post(
        path,
        data: serializedData,
        options: Options(
          headers: {
            "encryption": encryption.toString().split(".").last,
            "sender": sender,
          },
        ),
      );
    }

    return dio.get(path);
  }
}

enum Encryption { none, rsa, aes }

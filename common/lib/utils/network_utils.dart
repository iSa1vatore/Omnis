import 'dart:io';

import 'package:domain/model/network_address.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkUtils {
  static final _info = NetworkInfo();

  static getWifiIP() {
    return _info.getWifiIP();
  }

  static Future<List<NetworkAddress>> fetchDevicesNearby(
    String subnet,
    int port, {
    Duration timeout = const Duration(seconds: 2),
  }) async {
    List<NetworkAddress> out = [];

    final futures = <Future<Socket>>[];
    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';

      final Future<Socket> f = ping(host, port, timeout);
      futures.add(f);
      f.then((socket) {
        socket.destroy();
        out.add(NetworkAddress(host, port));
      }).catchError((dynamic e) {
        if (e is! SocketException) {
          throw e;
        }
      });
    }

    await Future.wait<Socket>(futures)
        .then<void>((sockets) {})
        .catchError((dynamic e) {});

    return out;
  }

  static Future<Socket> ping(String host, int port, Duration timeout) {
    return Socket.connect(host, port, timeout: timeout).then((socket) {
      return socket;
    });
  }
}

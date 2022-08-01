import 'package:domain/model/network_address.dart';
import 'package:shelf/shelf.dart';

import '../models/sender.dart';

extension ShelfRequestExtension on Request {
  Sender get sender {
    var data = headers["sender"]?.split(":");

    return Sender(
      address: NetworkAddress(data![0], int.parse(data[1])),
      globalUserId: data[2],
    );
  }

  String get encryption => headers["encryption"]!;

  Future<String> get body => readAsString();
}

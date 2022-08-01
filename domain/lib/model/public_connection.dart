import 'package:domain/model/connection.dart';

class PublicConnection extends Connection {
  PublicConnection({
    super.userId = 0,
    super.token = "",
    required super.address,
    super.encryptionPublicKey = "",
  });
}

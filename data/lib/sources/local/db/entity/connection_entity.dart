import 'package:floor/floor.dart';

@Entity(tableName: "Connections")
class ConnectionEntity {
  @primaryKey
  final int? id;
  final int userId;
  final String address;
  final int port;
  final String token;
  final String encryptionPublicKey;

  ConnectionEntity({
    this.id,
    required this.userId,
    required this.address,
    required this.port,
    required this.token,
    required this.encryptionPublicKey,
  });
}

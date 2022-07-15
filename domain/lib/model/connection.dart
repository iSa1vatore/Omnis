import 'network_address.dart';

class Connection {
  final int id;
  final int userId;
  final String token;
  final NetworkAddress address;
  final String encryptionPublicKey;

  Connection({
    required this.id,
    required this.userId,
    required this.token,
    required this.address,
    required this.encryptionPublicKey,
  });
}

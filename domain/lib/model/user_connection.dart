import 'network_address.dart';

class UserConnection {
  final NetworkAddress address;
  final String token;
  final String encryptionPublicKey;

  UserConnection({
    required this.address,
    required this.token,
    required this.encryptionPublicKey,
  });
}

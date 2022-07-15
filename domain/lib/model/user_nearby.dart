import 'network_address.dart';

class UserNearby {
  final String globalId;
  final String name;
  final String photo;
  final bool isClosed;
  final String encryptionPublicKey;
  final NetworkAddress address;

  UserNearby({
    required this.globalId,
    required this.name,
    required this.photo,
    required this.isClosed,
    required this.address,
    required this.encryptionPublicKey,
  });
}

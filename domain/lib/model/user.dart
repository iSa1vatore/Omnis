import 'network_address.dart';

class User {
  final int id;
  final String globalId;
  final String name;
  final String photo;
  final int lastOnline;
  
  final bool? isClosed;
  final String? encryptionPublicKey;
  final NetworkAddress? address;

  User({
    required this.id,
    required this.globalId,
    required this.name,
    required this.photo,
    required this.lastOnline,
    this.isClosed,
    this.encryptionPublicKey,
    this.address,
  });
}

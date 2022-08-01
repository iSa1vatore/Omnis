import 'network_address.dart';

class Connection {
  final int userId;
  final String token;
  final NetworkAddress address;
  final String encryptionPublicKey;

  Connection({
    required this.userId,
    required this.token,
    required this.address,
    required this.encryptionPublicKey,
  });

  Connection copyWith({
    int? userId,
    String? token,
    NetworkAddress? address,
    String? encryptionPublicKey,
  }) {
    return Connection(
      userId: userId ?? this.userId,
      token: token ?? this.token,
      address: address ?? this.address,
      encryptionPublicKey: encryptionPublicKey ?? this.encryptionPublicKey,
    );
  }
}

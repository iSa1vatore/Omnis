import 'package:domain/repository/private_keys_repository.dart';
import 'package:injectable/injectable.dart';

import '../sources/local/secure_storage.dart';

@Singleton(as: PrivateKeysRepository)
class PrivateKeysRepositoryImpl extends PrivateKeysRepository {
  final SecureStorage secureStorage;

  PrivateKeysRepositoryImpl({
    required this.secureStorage,
  });

  @override
  Future<String?> fetchEncryptionPrivateKey() => secureStorage.getString(
        key: PrivateKeysStorageKeys.encryptionPrivateKey,
      );

  @override
  Future<void> storeEncryptionPrivateKey(String privateKey) {
    return secureStorage.putString(
      key: PrivateKeysStorageKeys.encryptionPrivateKey,
      value: privateKey,
    );
  }
}

abstract class PrivateKeysStorageKeys {
  const PrivateKeysStorageKeys._();

  static const String encryptionPrivateKey = 'encryption-private-key';
}

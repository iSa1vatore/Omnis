abstract class PrivateKeysRepository {
  Future<String?> fetchEncryptionPrivateKey();

  Future<void> storeEncryptionPrivateKey(String privateKey);
}

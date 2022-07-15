import 'package:common/utils/random_utils.dart';
import 'package:crypton/crypton.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionUtils {
  static RSAKeypair rsaCreateKeypair() {
    return RSAKeypair.fromRandom();
  }

  static RSAPublicKey rsaPublicKeyFromString(String publicKey) {
    return RSAPublicKey.fromString(publicKey);
  }

  static String rsaEncrypt(RSAPublicKey publicKey, String message) {
    return publicKey.encrypt(message);
  }

  static String rsaDecrypt(RSAPrivateKey privateKey, String message) {
    return privateKey.decrypt(message);
  }

  static String rsaGetPublicKey(String privateKey) {
    return RSAPrivateKey
        .fromString(privateKey)
        .publicKey
        .toString();
  }

  static RSAPrivateKey rsaPrivateKeyFromString(String privateKey) {
    return RSAPrivateKey.fromString(privateKey);
  }

  static String aesEncrypt(String key, String message) {
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key.fromUtf8(key)),
    );

    final iv = encrypt.IV.fromUtf8(RandomUtils.generateString(16));

    final encrypted = encrypter.encrypt(message, iv: iv);

    return "${iv.base64}\n${encrypted.base64}";
  }

  static String aesDecrypt({
    required String key,
    required String ivKey,
    required String message,
  }) {
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key.fromUtf8(key)),
    );

    final iv = encrypt.IV.fromBase64(ivKey);

    return encrypter.decrypt(
      encrypt.Encrypted.fromBase64(message),
      iv: iv,
    );
  }
}

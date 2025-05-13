import 'package:encrypt/encrypt.dart';

class Encryptor {
  Encryptor._();
  static Encrypted encryptAES(
    String plainText, {
    required String rawKey,
    String? rawIv,
  }) {
    final key = Key.fromUtf8(rawKey);
    final iv = rawIv != null ? IV.fromUtf8(rawIv) : IV.fromLength(16);
    final encrypted = Encrypter(AES(key)).encrypt(plainText, iv: iv);
    return encrypted;
  }

  static String decryptAES(
    String encoded, {
    required String rawKey,
    String? rawIv,
  }) {
    final key = Key.fromUtf8(rawKey);
    final iv = rawIv != null ? IV.fromUtf8(rawIv) : IV.fromLength(16);
    final decrypted = Encrypter(AES(key)).decrypt16(encoded, iv: iv);
    return decrypted;
  }
}

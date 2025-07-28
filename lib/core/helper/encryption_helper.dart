import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  /// ✅ توليد مفتاح من الماستر باسوورد باستخدام SHA-256 (32 بايت)
  static encrypt.Key _generateKey(String masterPassword) {
    final keyBytes = sha256.convert(utf8.encode(masterPassword)).bytes;
    return encrypt.Key(Uint8List.fromList(keyBytes));
  }

  /// ✅ تشفير النص باستخدام AES-GCM مع IV عشوائي (16 بايت)
  static String encryptText(String plainText, String masterPassword) {
    try {
      final key = _generateKey(masterPassword);
      final iv = encrypt.IV.fromSecureRandom(16); // IV عشوائي
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.gcm),
      );

      final encrypted = encrypter.encrypt(plainText, iv: iv);

      // ندمج IV + النص المشفر في JSON ثم Base64
      final combined = jsonEncode({
        'iv': base64Encode(iv.bytes),
        'data': encrypted.base64,
      });

      return base64Encode(utf8.encode(combined));
    } catch (e) {
      throw Exception("فشل التشفير: $e");
    }
  }

  /// ✅ فك التشفير باستخدام AES-GCM
  static String decryptText(String encryptedText, String masterPassword) {
    try {
      final decoded = utf8.decode(base64Decode(encryptedText));
      final map = jsonDecode(decoded);

      final iv = encrypt.IV(base64Decode(map['iv']));
      final data = map['data'];

      final key = _generateKey(masterPassword);
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.gcm),
      );

      return encrypter.decrypt64(data, iv: iv);
    } catch (e) {
      throw Exception("فشل فك التشفير: $e");
    }
  }

  /// ✅ توليد Salt عشوائي (يستخدم مع Hash للماستر باسوورد)
  static String generateSalt([int length = 16]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  /// ✅ عمل Hash للباسوورد مع Salt باستخدام SHA-256
  static String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// ✅ توليد كلمة مرور قوية عشوائية
  static String generateSecurePassword() {
    const upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()-_=+[]{};:,.<>?';

    final rand = Random.secure();
    final length = 16 + rand.nextInt(17); // بين 16 و 32

    List<String> passwordChars = [];

    // ✅ إضافة على الأقل 3 من كل نوع
    passwordChars.addAll(_pickRandomChars(upperCase, 3, rand));
    passwordChars.addAll(_pickRandomChars(lowerCase, 3, rand));
    passwordChars.addAll(_pickRandomChars(numbers, 3, rand));
    passwordChars.addAll(_pickRandomChars(symbols, 3, rand));

    // ✅ إكمال الباقي حتى الطول المطلوب
    final allChars = upperCase + lowerCase + numbers + symbols;
    while (passwordChars.length < length) {
      passwordChars.add(allChars[rand.nextInt(allChars.length)]);
    }

    // ✅ خلط الأحرف
    passwordChars.shuffle(rand);

    return passwordChars.join();
  }

  static List<String> _pickRandomChars(String source, int count, Random rand) {
    return List.generate(count, (_) => source[rand.nextInt(source.length)]);
  }
}

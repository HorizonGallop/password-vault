import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pswrd_vault/core/models/user_model.dart';

class LocalUserStorage {
  static const _userKey = 'logged_in_user';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveUser(UserModel user) async {
    await _storage.write(key: _userKey, value: user.toJson());
  }

  Future<UserModel?> getUser() async {
    final jsonString = await _storage.read(key: _userKey);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonString);
  }

  Future<void> clearUser() async {
    await _storage.delete(key: _userKey);
  }
}

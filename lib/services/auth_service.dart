import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class AuthService {
//   final _storage = const FlutterSecureStorage();
//   final String _tokenKey = String.fromEnvironment('JWT_SECRET');

//   Future<void> saveToken(String token) async {
//     await _storage.write(key : _tokenKey, value : token);
//   }

//   Future<String?> getToken() async {
//     return await _storage.read(key : _tokenKey);
//   } 

//   Future<void> deleteToken() async {
//     await _storage.delete(key: _tokenKey);
//   }
// }

class AuthService {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens(String a, String r) async {
    await _storage.write(key: _accessKey, value: a);
    await _storage.write(key: _refreshKey, value: r);
  }

  Future<String?> getAccessToken() =>
      _storage.read(key: _accessKey);

  Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshKey);

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  Future<void> clear() => _storage.deleteAll();
}

import'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
 await _storage.write(key: _tokenKey, value: token);
  }

  Future<void>saveRefreshToken(String token) async {

    await _storage.write(key: _refreshTokenKey, value: token);
  }
  Future<String?>getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }
  Future<String?> getToken() async {

    return _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key:_refreshTokenKey);
  }
 
}
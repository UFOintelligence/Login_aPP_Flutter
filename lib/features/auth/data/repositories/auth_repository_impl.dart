import 'package:curso1/core/storage/secure_storage_service.dart';

import'../../domain/reposirories/auth_repository.dart';
import'../../domain/entities/user.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository{

  final AuthRemoteDatasource datasource;
  final SecureStorageService storage;

  AuthRepositoryImpl(
    this.datasource, 
    this.storage
    );

  @override
  Future<(String, User)> login({
    required String email,
    required String password,
  }) async {
  
  final (token, user) = await datasource.login(email, password);
  await storage.saveToken(token);
 // ⏳ FUTURO: cuando el backend esté listo
    // await storage.saveRefreshToken(refreshToken);
  return (token, user);
  
  }
}
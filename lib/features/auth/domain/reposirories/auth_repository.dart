import '../entities/user.dart';
abstract class AuthRepository {
  Future<(String token, User user)> login ({
    required String email,
    required String password,
  });
}
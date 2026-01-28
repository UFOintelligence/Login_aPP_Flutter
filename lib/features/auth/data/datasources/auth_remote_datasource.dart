import 'package:dio/dio.dart';
import 'package:curso1/core/network/api_exception.dart';
import 'models/user_model.dart';

class AuthRemoteDatasource {
  final Dio dio;
  AuthRemoteDatasource(this.dio);

  Future<(String, UserModel)> login(
    String email,
    String password,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data!;
      final token = data['token'] as String;
      final user =
          UserModel.fromJson(Map<String, dynamic>.from(data['user']));

      return (token, user);
    } on DioException catch (e) {
      //  Si el interceptor ya transformó el error
      if (e.error is ApiException) {
        throw e.error!;
      }

      // Error de red / timeout / inesperado
      throw ApiException(
        message: 'Error de conexión con el servidor',
      );
    }
  }
}

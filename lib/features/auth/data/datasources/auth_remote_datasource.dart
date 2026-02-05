import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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

      debugPrint('✅ LOGIN RESPONSE: ${response.data}');

      final data = response.data!;
      final token = data['token'] as String;

      final user = UserModel.fromJson(
        Map<String, dynamic>.from(data['user']),
      );

      return (token, user);

    } on DioException catch (e) {
      // 🔥 LOGS CLAROS
      debugPrint('❌ DIO ERROR TYPE: ${e.type}');
      debugPrint('❌ DIO MESSAGE: ${e.message}');
      debugPrint('❌ DIO RESPONSE: ${e.response?.data}');

      // ⛔ SIN RESPUESTA = problema de red / URL
      if (e.response == null) {
        throw ApiException(
          message: 'Error de conexión con el servidor',
        );
      }

      // ⛔ ERROR DEL BACKEND (401, 422, 500, etc)
      final statusCode = e.response?.statusCode ?? 0;
      final data = e.response?.data;

      throw ApiException(
        message: data?['message'] ?? 'Error en el servidor',
        statusCode: statusCode,
        data: data,
      );
    }
  }
}

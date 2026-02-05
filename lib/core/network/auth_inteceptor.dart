import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage_service.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'lock_refresh.dart';
class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService storage;
  final Ref ref;

  bool _isRefreshing = false;
  final List<Future<void> Function()> _retryQueue = [];

  AuthInterceptor(this.dio, this.storage, this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final refreshToken = await storage.getRefreshToken();

    // ❌ Sin refresh → logout
    if (refreshToken == null) {
      ref.read(authProvider.notifier).logout();
      return handler.next(err);
    }

    // 🔒 Ya hay refresh en curso → encolamos
    if (_isRefreshing) {
      _retryQueue.add(() async {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
      });
      return;
    }

    _isRefreshing = true;

    try {
      final response = await dio.post(
        '/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newToken = response.data['token'] as String;

      await storage.saveToken(newToken);

      // 🔁 Reintentar TODAS las requests en cola
      for (final retry in _retryQueue) {
        await retry();
      }

      _retryQueue.clear();

      // 🔁 Reintentar la request original
      final retryResponse = await dio.fetch(err.requestOptions);
      handler.resolve(retryResponse);
    } catch (_) {
      // ❌ Refresh falló → logout
      await storage.deleteToken();
      ref.read(authProvider.notifier).logout();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }
}


import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api/api_constants.dart';
import '../storage/secure_storage_provider.dart';
import 'auth_inteceptor.dart';
import '../constants/api/api_constants.dart';


final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final storage = ref.read(secureStorageProvider);

  dio.interceptors.add(
    AuthInterceptor(dio, storage, ref),
  );

  return dio;
});

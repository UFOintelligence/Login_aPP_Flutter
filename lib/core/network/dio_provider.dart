
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api/api_constants.dart';
import '../storage/secure_storage_provider.dart';
import 'auth_inteceptor.dart';


final dioProvider = Provider<Dio>((ref) {
final storage = ref.read(secureStorageProvider);

  final dio = Dio(
  BaseOptions(baseUrl: ApiConstans.baseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 30),
  sendTimeout: const Duration(seconds: 10),
  
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  }  )

  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.getToken();
        if( token != null){
          options.headers['Authorization'] = 'Bearer $token';
        }
      handler.next(options);

      }
    )
  );

  dio.interceptors.add(AuthInteceptor(storage, dio));
  return dio;
});

     
import 'package:curso1/core/network/api_exception.dart';
import 'package:curso1/core/storage/secure_storage_service.dart';
import'package:dio/dio.dart';
import '../storage/secure_storage_provider.dart';

class AuthInteceptor extends Interceptor {

  final SecureStorageService storage;
  final Dio dio;
  //bool _isRefreshing = false;
  AuthInteceptor(this.storage, this.dio);

  //Request
  @override
  Future<void>onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler
  )async{
    final token = await storage.getToken();
     print(' REQUEST → ${options.method} ${options.path}');
    print('TOKEN EN STORAGE: $token');

    if(token != null && token.isNotEmpty){
      options.headers['Authorization'] = 'Bearer $token';
       print('REQUEST ${options.method} ${options.path}');
    
    }else{
       print(' NO HAY TOKEN');
    }
    return handler.next(options);
  }
  // ======================
  // ERROR
  // ======================
@override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
   final  statusCode = err.response?.statusCode;
   
    // 401 → cerrar sesión
    if(statusCode == 401){
        print(' 401  logout automático');

        await storage.clearToken();
    }
    //  422  errores de formulario
    if(statusCode == 422){
      handler.reject(DioException(requestOptions: err.requestOptions,
      error: ApiException(
      message: 'Error de validación',
      statusCode: 422,
      data: err.response?.data
      )));
      return; 
    }
    // 500 Error del servidor
    if(statusCode == 500){
      handler.reject(DioException(requestOptions: err.requestOptions,
      error: ApiException(
      message: 'Error interno del servidor',
      statusCode: 500,
      data: err.response?.data
      ))
      );
      return;
    }
    handler.reject(DioException(requestOptions: err.requestOptions,
    error: ApiException(
    message: 'Error inesperado',
    statusCode: statusCode)));
}
}
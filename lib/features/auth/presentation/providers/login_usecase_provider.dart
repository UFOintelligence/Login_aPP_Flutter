import 'package:curso1/core/storage/secure_storage_provider.dart';
import 'package:curso1/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref){
final dio = ref.watch(dioProvider);
final datasource = AuthRemoteDatasource(dio);
final storage = ref.watch(secureStorageProvider);

final repository = AuthRepositoryImpl(
  datasource, 
  storage
  );

return LoginUseCase(repository);
});
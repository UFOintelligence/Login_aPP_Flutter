import 'package:curso1/core/storage/secure_storage_provider.dart';
import'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';
import 'login_usecase_provider.dart';

final authProvider =
 StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.read(loginUseCaseProvider);
  final storage = ref.read(secureStorageProvider);

  return AuthNotifier(loginUseCase, storage);
  
});



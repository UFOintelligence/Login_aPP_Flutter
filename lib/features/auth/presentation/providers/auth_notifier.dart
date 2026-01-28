import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';
import '../../../../core/storage/secure_storage_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final SecureStorageService storage;

  AuthNotifier(this.loginUseCase, this.storage)
      : super(const AuthState()) {
    checkAuth(); // 🔥 Se ejecuta al abrir la app
  }

  // ======================
  // CHECK AUTH (APP START)
  // ======================
  Future<void> checkAuth() async {
    debugPrint('🔍 checkAuth() ejecutándose...');
    state = state.copyWhith(isLoading: true);

    try {
      final token = await storage.getToken();

      if (token != null && token.isNotEmpty) {
        debugPrint(' TOKEN ENCONTRADO');
        debugPrint(' TOKEN: $token');

        state = state.copyWhith(
          token: token,
          isLoading: false,
        );
      } else {
        debugPrint(' NO HAY TOKEN GUARDADO');
        state = state.copyWhith(isLoading: false);
      }
    } catch (e) {
      debugPrint(' ERROR EN checkAuth: $e');
      state = state.copyWhith(isLoading: false);
    }
  }

  // =========
  // LOGIN
  // =========
  Future<void> login({
    required String email,
    required String password,
  }) async {
    debugPrint(' LOGIN INICIADO');
    state = state.copyWhith(isLoading: true, error: null);

    try {
      final (token, user) = await loginUseCase(
        email: email,
        password: password,
      );

      debugPrint(' LOGIN EXITOSO');
      debugPrint(' USUARIO: ${user.email}');
      debugPrint(' TOKEN: $token');

      // 🔥 GUARDAR TOKEN
      await storage.saveToken(token);
      debugPrint('💾 TOKEN GUARDADO EN SECURE STORAGE');

      state = state.copyWhith(
        isLoading: false,
        token: token,
        user: user,
      );
    } catch (e) {
      debugPrint(' ERROR EN LOGIN: $e');

      state = state.copyWhith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // =========
  // LOGOUT
  // =========
  Future<void> logout() async {
    debugPrint('LOGOUT');
    await storage.deleteToken();
    debugPrint(' TOKEN ELIMINADO');

    state = const AuthState();
  }
}

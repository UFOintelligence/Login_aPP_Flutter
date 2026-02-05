import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:curso1/features/auth/presentation/pages/home_page.dart';
import 'package:curso1/features/auth/presentation/pages/login_page.dart';
import 'package:curso1/features/auth/presentation/pages/splash_page.dart';
import 'package:curso1/features/auth/presentation/providers/auth_provider.dart';
import 'package:curso1/features/auth/presentation/providers/auth_state.dart';
import 'package:curso1/core/ui/snackbar_helper.dart';

class AppEntry extends ConsumerWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔥 Escuchar errores de auth (Snackbars automáticos)
    ref.listen<AuthState>(authProvider, (prev, next) {
      final error = next.error;

      if (error != null && error != prev?.error) {
        SnackbarHelper.show(context, error);
      }
    });

    final auth = ref.watch(authProvider);

    // Splash mientras se valida sesión
    if (auth.isLoading) {
      return const SplashPage();
    }

    //  Usuario autenticado
    if (auth.token != null) {
      return const HomePage();
    }

    //  No autenticado
    return const LoginPage();
  }
}

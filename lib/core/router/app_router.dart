import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../router/go_router_refresh_stream.dart';
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',

    redirect: (context, state) {
      final loggedIn = auth.token != null;
      final loggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/splash';

      // ⛔ NO redirigir mientras se valida sesión
      if (auth.isLoading) {
        return isSplash ? null : '/splash';
      }

      // 🔐 No logueado
      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }

      // ✅ Logueado
      if (loggedIn && (loggingIn || isSplash)) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomePage(),
      ),
    ],
  );
});

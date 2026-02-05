import 'package:curso1/app/app_entry.dart';
import 'package:curso1/core/router/app_router.dart';
import 'package:curso1/features/auth/presentation/pages/home_page.dart';
import 'package:curso1/features/auth/presentation/pages/login_page.dart';
import 'package:curso1/features/auth/presentation/pages/splash_page.dart';
import 'package:curso1/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curso1/core/ui/network_listener.dart';
import 'package:curso1/core/network/connectivity_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Activa el listener de conectividad (UNA VEZ)
    ref.watch(connectivityListenerProvider);

   final router = ref.watch(routerProvider);

    return NetworkListener(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}

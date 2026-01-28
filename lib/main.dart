import 'package:curso1/features/auth/presentation/pages/home_page.dart';
import 'package:curso1/features/auth/presentation/pages/login_page.dart';
import 'package:curso1/features/auth/presentation/pages/splash_page.dart';
import 'package:curso1/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main(){
  runApp(
    
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/splash',
  routes: {
    '/splash': (_) => const SplashPage(),
    '/login': (_) => const LoginPage(),
    '/home': (_) => const HomePage(),
  },
);

  }
}

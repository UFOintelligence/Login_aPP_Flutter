import 'package:curso1/features/auth/presentation/providers/auth_notifier.dart';
import 'package:curso1/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginPage extends  ConsumerWidget{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final AuthState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login'),),
      body: Center(
        child: AuthState.isLoading ? 
        const CircularProgressIndicator() : 
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
         ref.read(authProvider.notifier).login(
                  email: 'admin@test.com', 
                  password: '123456'
                  
                  );
              },
              child: Text('Login'),
              
              ),
              if (AuthState.error != null)
              Text(
                AuthState.error!,
                style: const TextStyle(color: Colors.red),
              ),
              if(AuthState.user != null)
              Text('Bienvenido ${AuthState.user!.name}'),
              
          ],
        )

        
        ),
      );

  



  }
}
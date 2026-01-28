import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/network/dio_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    // 🔥 Escuchar logout automático
    ref.listen(authProvider, (previous, next) {
      if (previous?.token != null && next.token == null) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bienvenido ${auth.user?.name ?? ''}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // 🔥 BOTÓN TEST REQUEST
            ElevatedButton(
              onPressed: () async {
                final dio = ref.read(dioProvider);

                try {
                  final response = await dio.get('/user');
                  debugPrint('✅ RESPONSE /user: ${response.data}');
                } catch (e) {
                  debugPrint('❌ ERROR /user: $e');
                }
              },
              child: const Text('Probar request protegido'),
            ),
          ],
        ),
      ),
    );
  }
}

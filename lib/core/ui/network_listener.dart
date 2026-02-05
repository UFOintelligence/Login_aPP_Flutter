import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/connectivity_provider.dart';

class NetworkListener extends ConsumerWidget {
  const NetworkListener({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<bool>(connectivityProvider, (prev, next) {
      if (prev == null) return;

      if (!next) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(' Sin conexión a internet'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (prev == false && next == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(' Con conexión'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });

    return child;
  }
}

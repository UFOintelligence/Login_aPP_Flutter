import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityProvider = StateProvider<bool>((ref) {
  return true; // asumimos conexión al inicio
});

final connectivityListenerProvider = Provider<void>((ref) {
  final connectivity = Connectivity();

  StreamSubscription? sub;

  sub = connectivity.onConnectivityChanged.listen((result) {
    final hasConnection = result != ConnectivityResult.none;
    ref.read(connectivityProvider.notifier).state = hasConnection;
  });

  ref.onDispose(() {
    sub?.cancel();
  });
});

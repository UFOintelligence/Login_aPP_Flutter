import 'dart:async';

class RefreshTokenManager {

  static bool _isRefreshing = false;
  static  Completer<void>? _completer;

  static  bool get isRefreshing => _isRefreshing;

  static Future<void> wait() async {
    await _completer?.future;

  }
  static void start() {
    _isRefreshing = true;
    _completer = Completer<void>();
  }

  static void finish() {
    _isRefreshing = false;
    _completer?.complete();
    _completer = null;
  }

}
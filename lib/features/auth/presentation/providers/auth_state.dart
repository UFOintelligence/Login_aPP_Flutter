import 'package:curso1/core/network/api_exception.dart';

import '../../domain/entities/user.dart';

class AuthState {
  final bool isLoading;
  final  User? user;
  final String? token;
  final ApiException? error; 

  const AuthState({
    this.isLoading =  false,
    this.user,
    this.token,
    this.error
  });
 AuthState copyWhith({
  bool? isLoading,
  User? user,
  String? token,
  ApiException? error,
 }) {
  return AuthState(
    isLoading: isLoading ?? this.isLoading,
    user: user ?? this.user,
    token: token ?? this.token,
    error: error 
  );
 }
} 


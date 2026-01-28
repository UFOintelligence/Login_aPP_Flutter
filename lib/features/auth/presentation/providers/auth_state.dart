import '../../domain/entities/user.dart';

class AuthState {
  final bool isLoading;
  final  User? user;
  final String? token;
  final String? error; 

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
  String? error
 }) {
  return AuthState(
    isLoading: isLoading ?? this.isLoading,
    user: user ?? this.user,
    token: token ?? this.token,
    error: error 
  );
 }
} 


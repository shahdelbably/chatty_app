part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthSuccessWithUser extends AuthState {
  final User user;
  AuthSuccessWithUser(this.user);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
// part of 'auth_cubit.dart';

// @immutable
// sealed class AuthState {}

// class AuthInitial extends AuthState {}

// class AuthLoading extends AuthState {}

// class AuthSuccess extends AuthState {}

// class AuthFailure extends AuthState {
//   final String error;
//   AuthFailure(this.error);
// }

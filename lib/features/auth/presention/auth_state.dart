import '../domain/models/app_user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthOnRegister extends AuthState {
  final String userId;

  AuthOnRegister(this.userId);
}

class AuthOnConfirm extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

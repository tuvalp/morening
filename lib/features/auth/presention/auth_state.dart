import '../domain/models/app_user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class Unconfirmed extends AuthState {}

class RegisterOnConfirm extends AuthState {
  final String? userId;
  final String? email;
  final String? password;
  final String? name;
  final String? error;

  RegisterOnConfirm(
      this.userId, this.email, this.password, this.name, this.error);
}

class RegisterOnTerms extends AuthState {
  final String? userId;
  final String? email;
  final String? password;
  final String? name;
  final String? error;

  RegisterOnTerms(
      this.userId, this.email, this.password, this.name, this.error);
}

class RegisterOnQuestion extends AuthState {
  final String? userId;
  final String? email;
  final String? password;
  final String? name;
  final String? error;

  RegisterOnQuestion(
      this.userId, this.email, this.password, this.name, this.error);
}

class AuthOnRegisterSuccess extends AuthState {}

class wakeUpProfileMiss extends AuthState {
  final AppUser user;

  wakeUpProfileMiss(this.user);
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

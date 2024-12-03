abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthOnRegister extends AuthState {
  AuthOnRegister();
}

class AuthRegisterSuccess extends AuthState {}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

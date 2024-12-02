abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUserLoaded extends AuthState {
  final String user;

  AuthUserLoaded(this.user);
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

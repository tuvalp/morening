import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_cognito_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCognitoRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial()) {
    getCurrentUser();
  }

  void getCurrentUser() async {
    emit(AuthLoading());

    final user = await _authRepo.getUser();

    if (user == null) {
      emit(Unauthenticated());
    } else {
      emit(Authenticated(user));
    }
  }

  void login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepo.login(email, password);
      getCurrentUser();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      await _authRepo.register(email, password, name);
      emit(AuthOnRegister());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void confirmUser(String confirmationCode, String email) async {
    emit(AuthLoading());
    try {
      await _authRepo.confirmUser(confirmationCode, email);
      emit(AuthRegisterSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void logout() async {
    emit(AuthLoading());
    try {
      print('Attempting logout...'); // Debug log
      await _authRepo.logout();
      print('Logout successful, emitting Unauthenticated...'); // Debug log
      emit(Unauthenticated());
    } catch (e) {
      print('Error during logout: $e'); // Debug log
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_api_repo.dart';
import '../data/auth_cognito_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCognitoRepo _authRepo;
  final AuthApiRepo _apiRepo;

  AuthCubit(this._authRepo, this._apiRepo) : super(AuthInitial()) {
    getCurrentUser();
  }

  /// Fetches the current user and updates the state accordingly.
  Future<void> getCurrentUser() async {
    emit(AuthLoading());
    try {
      final userID = await _authRepo.getUser();
      if (userID == null) {
        emit(Unauthenticated());
        return;
      }

      final user = await _apiRepo.getUser(userID);

      if (user.email.isEmpty) {
        await _authRepo.logout();
        emit(Unauthenticated());
        return;
      }

      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError("Failed to fetch user: ${e.toString()}"));
    }
  }

  /// Logs the user in using email and password.
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepo.login(email, password);
      await getCurrentUser();
    } catch (e) {
      emit(AuthError("Login failed: ${e.toString()}"));
    }
  }

  /// Registers a new user with the given details.
  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final userId = await _authRepo.register(email, password, name);
      emit(AuthOnRegister(userId!));
    } catch (e) {
      emit(AuthError("Registration failed: ${e.toString()}"));
    }
  }

  /// Confirms the user's account with a confirmation code.
  Future<void> confirmUser(String confirmationCode, String email) async {
    emit(AuthLoading());
    try {
      await _authRepo.confirmUser(confirmationCode, email);
      emit(AuthOnConfirm());
    } catch (e) {
      emit(AuthError("Confirmation failed: ${e.toString()}"));
    }
  }

  Future<void> registerUser(String id, String email, String name,
      String password, String answers) async {
    emit(AuthLoading());
    try {
      await _apiRepo.register(id, email, name, answers);
      await _authRepo.login(email, password);
    } catch (e) {
      emit(AuthError("Registration failed: ${e.toString()}"));
    }
  }

  /// Logs out the current user.
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authRepo.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError("Logout failed: ${e.toString()}"));
    }
  }
}

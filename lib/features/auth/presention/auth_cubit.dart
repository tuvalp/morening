import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/auth/data/auth_api_repo.dart';
import '../data/auth_cognito_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCognitoRepo _authRepo;
  final AuthApiRepo _apiRepo;

  AuthCubit(this._authRepo, this._apiRepo) : super(AuthInitial()) {
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    emit(AuthLoading());

    final userID = await _authRepo.getUser();
    if (userID == null) {
      emit(Unauthenticated());
      return;
    }

    final user = await _apiRepo.getUser(userID);
    emit(Authenticated(user));
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepo.login(email, password);
      await getCurrentUser();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final userId = await _authRepo.register(email, password, name);
      await _apiRepo.register(userId.toString(), email, name);
      emit(AuthOnRegister());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> confirmUser(String confirmationCode, String email) async {
    emit(AuthLoading());
    try {
      await _authRepo.confirmUser(confirmationCode, email);
      emit(AuthRegisterSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authRepo.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }
}

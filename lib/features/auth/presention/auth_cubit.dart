import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_cognito_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCognitoRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<String> getCurrentUser() async {
    try {
      final user = await _authRepo.getUser();
      emit(AuthUserLoaded(user));
      return user;
    } catch (e) {
      emit(AuthError('Failed to get current user: $e'));
      return '';
    }
  }

  void login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepo.login(email, password);
      await getCurrentUser();
    } catch (e) {
      emit(AuthError('Failed to login: $e'));
    }
  }

  void register(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepo.register(email, password);
      await getCurrentUser();
    } catch (e) {
      emit(AuthError('Failed to register: $e'));
    }
  }
}

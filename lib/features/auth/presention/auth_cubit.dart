import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/questionnaire/presention/pages/set_up_questionaire.dart';
import 'package:morening_2/services/navigation_service.dart';
import '../data/auth_api_repo.dart';
import '../data/auth_cognito_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCognitoRepo _authRepo;
  final AuthApiRepo _apiRepo;

  AuthCubit(this._authRepo, this._apiRepo) : super(AuthInitial()) {
    getCurrentUser();
  }

  Future<bool> getCurrentUser() async {
    emit(AuthLoading());
    try {
      final userID = await _authRepo.getUser();
      if (userID == null) {
        print("userID is null");
        emit(Unauthenticated());
        return false;
      }

      final user = await _apiRepo.getUser(userID);

      if (user.email.isEmpty) {
        print("user.email is empty");
        await _authRepo.logout();
        emit(Unauthenticated());

        return false;
      }

      if (user.wakeUpProfile == null) {
        print("user.wakeUpProfile is empty");
        emit(Authenticated(user)); // Emit state before navigation
        NavigationService.navigateTo(
          SetUpQuestionaire(userID: userID),
          replace: true,
        );
      }

      emit(Authenticated(user));
      return true;
    } catch (e) {
      print("Error getting user: $e");
      emit(Unauthenticated());
      return false;
    }
  }

  /// Logs the user in using email and password.
  Future<bool> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepo.login(email, password);
      await getCurrentUser().then((value) {
        if (value == false) {
          emit(Unauthenticated());
          return false;
        }
      });

      return true;
    } catch (e) {
      emit(AuthError("Login failed: ${e.toString()}"));
      return false;
    }
  }

  /// Registers a new user with the given details.
  Future<String?> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final userId = await _authRepo.register(email, password, name);

      emit(RegisterOnConfirm(userId!, email, password, name, null));
      return userId;
    } catch (e) {
      emit(AuthError(e.toString()));
      return null;
    }
  }

  Future<bool> confirmUser(String confirmationCode, String userId, String email,
      String password, String name) async {
    emit(AuthLoading());
    try {
      await _authRepo.confirmUser(confirmationCode, email);
      await _apiRepo.register(userId, email, name);
      await login(email, password);

      return true;
    } catch (e) {
      emit(AuthError(e.toString()));
      return false;
    }
  }

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

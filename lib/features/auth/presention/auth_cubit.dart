import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_api_repo.dart';
import '../data/auth_cognito_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCognitoRepo _authRepo;
  final AuthApiRepo _apiRepo;

  AuthCubit(this._authRepo, this._apiRepo) : super(AuthInitial()) {
    isAuthenticated();
  }

  Future<bool> isAuthenticated() async {
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
        emit(AuthError("No internet connection, place try agian later"));

        return false;
      }

      final isWakeUpProfileSet = await _apiRepo.getWakeupProfile(userID);

      if (isWakeUpProfileSet == null) {
        emit(WakeupUnset(user));
        return true;
      } else if (isWakeUpProfileSet.statusCode == 500) {
        emit(AuthError(isWakeUpProfileSet.data['message']));
        return false;
      }

      emit(Authenticated(user));
      return true;
    } catch (e) {
      print("Error getting user: $e");
      emit(Unauthenticated());
      _authRepo.logout();

      return false;
    }
  }

  Future<void> getCurrentUser() async {
    final userID = await _authRepo.getUser();
    if (userID != null) {
      final user = await _apiRepo.getUser(userID);
      emit(Authenticated(user));
    }
  }

  /// Logs the user in using email and password.
  Future<bool> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepo.login(email, password);
      await isAuthenticated().then((value) {
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
      print(e.toString());
      return false;
    }
  }

  Future<void> resendConfirmationCode(String email) async {
    await _authRepo.resendConfirmationCode(email);
  }

  Future<bool> setWakeupProfile(
      String userId, List<Map<String, dynamic>> wakeUpProfile) async {
    emit(AuthLoading());
    try {
      await _apiRepo.setWakeupProfile(userId, wakeUpProfile);
      await isAuthenticated();
      return true;
    } catch (e) {
      emit(AuthError(e.toString()));
      return false;
    }
  }

  Future<bool> setDailyQuestions(
      String userId, List<Map<String, dynamic>> questions) async {
    try {
      await _apiRepo.setDailyQuestions(userId, questions);
      return true;
    } catch (e) {
      print(e);
      emit(AuthError(e.toString()));
      return false;
    }
  }

  Future<bool> sendRestPassword(String email) async {
    try {
      await _authRepo.forgotPassword(email);
      return true;
    } catch (e) {
      emit(AuthError(e.toString()));
      return false;
    }
  }

  Future<bool> resetPassword(String email, String code, String password) async {
    try {
      await _authRepo.updatePassword(email, code, password);
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

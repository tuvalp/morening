import 'package:amplify_flutter/amplify_flutter.dart';
import '../domain/repository/auth_repo.dart';

class AuthCognitoRepo implements AuthRepo {
  @override
  Future<String?> getUser() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      return user.userId;
    } catch (e) {
      if (e is SignedOutException) {
        return null;
      }
      throw Exception("Error getting user: $e");
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      // Sign in with email and password
      SignInResult result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        print('User logged in successfully');
      } else {
        print('Login failed');
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  @override
  Future<String?> register(String email, String password, String name) async {
    try {
      // Sign up a new user with email and password
      SignUpResult result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            CognitoUserAttributeKey.email: email,
            CognitoUserAttributeKey.name: name
          },
        ),
      );

      if (result.userId != null) {
        return result.userId;
      } else {
        return null;
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  @override
  Future<void> confirmUser(String confirmationCode, email) async {
    try {
      // Confirm the user's sign-up
      await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
      print('User confirmed successfully');
    } catch (e) {
      print('Error during confirmation: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Sign out the current user
      await Amplify.Auth.signOut();
      print('User logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}

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

  Future<bool> isUserConfirmed() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      final emailVerified = result.firstWhere(
          (attr) => attr.userAttributeKey == AuthUserAttributeKey.emailVerified,
          orElse: () => AuthUserAttribute(
              userAttributeKey: AuthUserAttributeKey.emailVerified,
              value: 'false'));

      return emailVerified.value == 'true';
    } on AuthException catch (e) {
      print('Error fetching user attributes: ${e.message}');
      return false;
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

  Future<void> forgotPassword(String email) async {
    try {
      // Send a forgot password request to the user
      await Amplify.Auth.resetPassword(username: email);
      print('Password reset email sent successfully');
    } catch (e) {
      print('Error during password reset: $e');
      rethrow;
    }
  }

  Future<void> updatePassword(
      String email, String confirmationCode, String newPassword) async {
    try {
      // Update the user's password
      await Amplify.Auth.confirmResetPassword(
        username: email,
        confirmationCode: confirmationCode,
        newPassword: newPassword,
      );
      print('Password updated successfully');
    } catch (e) {
      print('Error during password update: $e');
      rethrow;
    }
  }

  Future<void> resendConfirmationCode(String email) async {
    try {
      // Resend the confirmation code to the user
      await Amplify.Auth.resendSignUpCode(username: email);
      print('Confirmation code resent successfully');
    } catch (e) {
      print('Error during confirmation code resend: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await Amplify.Auth.deleteUser();
    } catch (e) {
      print('Error during deletion: $e');
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

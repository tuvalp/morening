import 'package:amplify_flutter/amplify_flutter.dart';

class AppUser {
  final String id;
  final String email;

  AppUser({required this.id, required this.email});

  factory AppUser.toAppUser(AuthUser user) {
    return AppUser(
      id: user.userId,
      email: user.username,
    );
  }
}

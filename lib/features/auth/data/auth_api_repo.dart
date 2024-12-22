import '../../../services/api_service.dart';
import '/features/auth/domain/models/app_user.dart';
import 'dart:convert';

class AuthApiRepo {
  Future<void> register(String id, String email, String name) {
    return ApiService.post("add_user", {
      "id": id,
      "email": email,
      "name": name,
      "wake_up_profile": "",
    });
  }

  Future<AppUser> getUser(String id) {
    return ApiService.post("get_user", {"id": id})
        .then((value) => AppUser.fromJson(jsonDecode(value.body)));
  }
}

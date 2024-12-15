import '../../../services/api_service.dart';
import '/features/auth/domain/models/app_user.dart';
import 'dart:convert';

class AuthApiRepo {
  Future<void> register(String id, String email, String name) {
    AppUser newUser = AppUser(id: id, email: email, name: name);
    return ApiService.post("add_user", newUser.toJson());
  }

  Future<AppUser> getUser(String id) {
    return ApiService.post("get_user", {"id": id})
        .then((value) => AppUser.fromJson(jsonDecode(value.body)));
  }
}

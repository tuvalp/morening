import '../../../services/api_service.dart';
import '/features/auth/domain/models/app_user.dart';

class AuthApiRepo {
  Future<void> register(String id, String email, String name) {
    return ApiService().post("users/add_user", {
      "user_id": id,
      "email": email,
      "name": name,
    });
  }

  Future<AppUser> getUser(String id) async {
    try {
      final response =
          await ApiService().get("users/get_user", {"user_id": id});
      final data = response.data;
      return AppUser.fromJson(data);
    } catch (e) {
      throw Exception("Failed to retrieve user: $e");
    }
  }

  Future<void> setWakeupProfile(String userId, String profile) async {
    try {
      await ApiService().post("users/update_wake_up_profile", {
        "user_id": userId,
        "wake_up_profile": profile,
      });
    } catch (e) {
      throw Exception("Failed to set wakeup profile: $e");
    }
  }
}

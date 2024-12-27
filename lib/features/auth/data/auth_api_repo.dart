import '../../../services/api_service.dart';
import '/features/auth/domain/models/app_user.dart';

class AuthApiRepo {
  Future<void> register(String id, String email, String name) {
    return ApiService().post("add_user", {
      "id": id,
      "email": email,
      "name": name,
      "wake_up_profile": "{}",
    });
  }

  Future<AppUser> getUser(String id) async {
    try {
      final response = await ApiService().post("get_user", {"id": id});
      final data = response.data;
      return AppUser.fromJson(data);
    } catch (e) {
      throw Exception("Failed to retrieve user: $e");
    }
  }
}

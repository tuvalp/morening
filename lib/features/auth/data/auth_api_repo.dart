import 'package:dio/dio.dart';

import '../../../services/api_service.dart';
import '/features/auth/domain/models/app_user.dart';

class AuthApiRepo {
  final _apiService = ApiService();
  Future<void> register(String id, String email, String name) {
    return _apiService.post("users/add_user", {
      "user_id": id,
      "email": email,
      "name": name,
    });
  }

  Future<AppUser> getUser(String id) async {
    try {
      final response = await _apiService.get("users/get_user", {"user_id": id});
      final data = response.data;
      return AppUser.fromJson(data);
    } catch (e) {
      throw Exception("Failed to retrieve user: $e");
    }
  }

  Future<Response?> getWakeupProfile(String userId) async {
    try {
      final response = await _apiService.get(
        "users/get_wake_up_profile",
        {"user_id": userId},
      );
      return response;
    } catch (e) {
      return null;
      //throw Exception("Failed to get wakeup profile: $e");
    }
  }

  Future<void> setWakeupProfile(
      String userId, List<Map<String, dynamic>> profile) async {
    try {
      await _apiService.postWithBody(
        "users/add_wake_up_profile",
        {"user_id": userId},
        {
          "user_id": userId,
          "wake_up_profile": profile, // Pass the list directly, not as a string
        },
      );
    } catch (e) {
      throw Exception("Failed to set wakeup profile: $e");
    }
  }

  Future<void> setDailyQuestions(
      String userId, List<Map<String, dynamic>> questions) async {
    try {
      await _apiService.postWithBody(
        "users/set_daily_qustions",
        {"user_id": userId},
        {
          "user_id": userId,
          "daily_questions": questions,
        },
      );
    } catch (e) {
      throw Exception("Failed to set wakeup profile: $e");
    }
  }
}

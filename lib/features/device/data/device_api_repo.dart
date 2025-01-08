import '../../../services/api_service.dart';

class DeviceApiRepo {
  final _apiService = ApiService();
  Future<bool> pairDevice(String deviceId, String userID) async {
    try {
      await _apiService.post(
        "users/pair_user_with_device",
        {"user_id": userID, "device_id": deviceId},
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> unpairDevice(String userID) async {
    try {
      await _apiService.post(
        "users/unpair_device",
        {
          "user_id": userID,
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> checkDeviceStatus(String userID) async {
    try {
      final response = await _apiService.get(
        "device/device_connection_status",
        {"user_id": userID},
      );
      return response.data["device_status"] ?? "Unknown status";
    } catch (e) {
      print(e);
      return "Unknown status";
    }
  }
}

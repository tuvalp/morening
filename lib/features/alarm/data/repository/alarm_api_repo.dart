import 'package:intl/intl.dart';
import 'package:morening_2/features/alarm/domain/models/alarm.dart';
import 'package:morening_2/services/api_service.dart';

class AlarmApiRepo {
  final ApiService _apiService = ApiService();

  Future<void> addAlarm(Alarm alarm, String? userID) {
    _apiService.post("set_alarm", {
      "user_id": userID,
      "uuid": alarm.id,
      "time": DateFormat('yyyy-MM-dd HH:mm:ss').format(alarm.time),
    });
    return Future.value();
  }

  Future<void> updateAlarm(Alarm alarm, String? userID) {
    _apiService.post("update_alarm", {
      "user_id": userID,
      "uuid": alarm.id,
      "is_active": alarm.isActive,
      "time": DateFormat('yyyy-MM-dd HH:mm:ss').format(alarm.time),
    });
    return Future.value();
  }

  Future<void> removeAlarm(Alarm alarm, String? userID) {
    _apiService.post("remove_alarm", {
      "user_id": userID,
      "uuid": alarm.id,
    });
    return Future.value();
  }
}

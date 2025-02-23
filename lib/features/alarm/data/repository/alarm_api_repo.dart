import 'package:intl/intl.dart';
import '/features/alarm/domain/models/alarm.dart';
import '/services/api_service.dart';

class AlarmApiRepo {
  final ApiService _apiService = ApiService();

  Future<void> addAlarm(Alarm alarm, String? userID, String timeZone) async {
    _apiService.post("alarm/set_alarm", {
      "user_id": userID,
      "alarm_uuid": alarm.id,
      "alarm_time": DateFormat('yyyy-MM-dd HH:mm:ss').format(alarm.time),
      "alarm_type": "ai_defined_schedule",
      "time_zone": timeZone,
    });
    return Future.value();
  }

  Future<void> updateAlarm(Alarm alarm, String? userID, String timeZone) {
    _apiService.post("alarm/update_alarm", {
      "user_id": userID,
      "alarm_uuid": alarm.id,
      "alarm_time": DateFormat('yyyy-MM-dd HH:mm:ss').format(alarm.time),
      "is_active": alarm.isActive,
      "alarm_type": "ai_defined_schedule",
      "time_zone": timeZone,
    });
    return Future.value();
  }

  Future<void> removeAlarm(Alarm alarm, String? userID) {
    _apiService.delete("alarm/remove_alarm", {
      "user_id": userID,
      "alarm_uuid": alarm.id,
    });
    return Future.value();
  }
}

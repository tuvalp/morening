import 'package:morening_2/features/alarm/domain/models/alarm.dart';
import 'package:morening_2/services/api_service.dart';

class AlarmApiRepo {
  final ApiService _apiService = ApiService();

  Future<void> addAlarm(Alarm alarm, String? userID) {
    _apiService.post("setAlarm", {
      "user_id": userID,
      "uuid": alarm.id,
      "time": alarm.time,
    });
    return Future.value();
  }
}

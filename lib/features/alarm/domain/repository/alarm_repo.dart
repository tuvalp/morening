import '../../../alarm/domain/models/alarm.dart';

abstract class AlarmRepo {
  Future<List<Alarm>> getAlarms();
  Future<Alarm> getAlarm(int id);
  Future<void> addAlarm(Alarm alarm);
  Future<void> removeAlarm(Alarm alarm);
  Future<void> updateAlarm(Alarm alarm);
  Future<void> stopAlarm(Alarm alarm);
}

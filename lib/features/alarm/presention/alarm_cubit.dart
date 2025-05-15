import 'package:alarm/alarm.dart' show AlarmSettings;
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/alarm/data/repository/alarm_api_repo.dart';
import '../../alarm/domain/models/alarm.dart';
import '../data/repository/alarm_native_repo.dart';
import '../domain/repository/alarm_repo.dart';
import 'alarm_state.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class AlarmCubit extends Cubit<AlarmState> {
  final AlarmRepo alarmRepo;
  final AlarmNativeRepo alarmNativeRepo;
  final AlarmApiRepo alarmApiRepo;

  AlarmCubit(this.alarmRepo, this.alarmNativeRepo, this.alarmApiRepo)
      : super(const AlarmInitial()) {
    loadAlarms();
  }

  void onAlarmRing(AlarmSettings alarm) {
    emit(AlarmRingingState(alarm));
  }

  Future<void> loadAlarms() async {
    emit(AlarmLoading());
    try {
      final alarms = await alarmRepo.getAlarms();
      alarms.sort((a, b) => a.id.compareTo(b.id));
      emit(AlarmLoaded(alarms));
    } catch (error) {
      emit(AlarmError('Failed to load alarms: $error'));
    }
  }

  Future<void> addAlarm(Alarm alarm, String? userID) async {
    final String timeZone = await FlutterTimezone.getLocalTimezone();

    try {
      emit(AlarmLoading());
      final now = DateTime.now();
      final adjustedAlarm = await _getAdjustedAlarm(alarm, now);

      await alarmRepo.addAlarm(alarm);
      await alarmNativeRepo.addAlarm(adjustedAlarm);
      await alarmApiRepo.addAlarm(adjustedAlarm, userID, timeZone);

      loadAlarms();
    } catch (error) {
      emit(AlarmError('Failed to add alarm: $error'));
    }
  }

  Future<void> removeAlarm(Alarm alarm, String? userID) async {
    try {
      emit(AlarmLoading());
      await alarmRepo.removeAlarm(alarm);
      await alarmNativeRepo.removeAlarm(alarm.id);
      await alarmApiRepo.removeAlarm(alarm, userID);
      loadAlarms();
    } catch (error) {
      emit(AlarmError('Failed to remove alarm: $error'));
    }
  }

  Future<void> updateAlarm(Alarm alarm, String? userID) async {
    try {
      final now = DateTime.now();
      final adjustedAlarm = await _getAdjustedAlarm(alarm, now);
      final String timeZone = await FlutterTimezone.getLocalTimezone();

      await alarmApiRepo.updateAlarm(adjustedAlarm, userID, timeZone);
      await alarmRepo.updateAlarm(alarm);
      await alarmNativeRepo.updateAlarm(adjustedAlarm);

      loadAlarms();
    } catch (error) {
      emit(AlarmError('Failed to update alarm: $error'));
    }
  }

  Future<void> toggleAlarmActive(Alarm alarm, String? userID) async {
    try {
      final updatedAlarm = alarm.toggleActive();
      await updateAlarm(updatedAlarm, userID);
    } catch (error) {
      emit(AlarmError('Failed to toggle alarm: $error'));
    }
  }

  Future<void> stopAlarm(int id) async {
    try {
      emit(AlarmInitial());
      final alarm = await alarmRepo.getAlarm(id);
      await alarmNativeRepo.removeAlarm(id);

      if (alarm.days.isNotEmpty) {
        final now = DateTime.now();
        final adjustedAlarm = await _getAdjustedAlarm(alarm, now);
        await alarmNativeRepo.addAlarm(adjustedAlarm);
      } else {
        final updatedAlarm = alarm.copyWith(isActive: false);
        await alarmRepo.updateAlarm(updatedAlarm);
      }

      loadAlarms();
    } catch (error) {
      emit(AlarmError('Failed to stop alarm: $error'));
    }
  }

  Future<void> snoozeAlarm(int id) async {
    try {
      emit(AlarmInitial());
      final alarm = await alarmRepo.getAlarm(id);
      final newtime = DateTime.now()
          .add(const Duration(minutes: 5))
          .copyWith(second: 0, microsecond: 0);
      final updatedAlarm = alarm.copyWith(isActive: true, time: newtime);
      await alarmNativeRepo.addAlarm(updatedAlarm);
      loadAlarms();
    } catch (error) {
      emit(AlarmError('Failed to stop alarm: $error'));
    }
  }

  Future<Alarm> _getAdjustedAlarm(Alarm alarm, DateTime now) async {
    final adjustedNow = now.copyWith(second: 0, millisecond: 0);
    if (alarm.days.isEmpty) {
      // If no days are specified, schedule for tomorrow if time has passed
      final nextAlarmTime = alarm.time.isBefore(adjustedNow)
          ? DateTime(now.year, now.month, now.day + 1, alarm.time.hour,
              alarm.time.minute)
          : alarm.time;
      return alarm.copyWith(time: nextAlarmTime);
    } else if (alarm.days.contains(adjustedNow.weekday)) {
      // If today is in the alarm days, but the time has passed
      if (alarm.time.isBefore(adjustedNow)) {
        final nextDay = _getNextDay(alarm.days, adjustedNow.weekday);
        final nextAlarmTime =
            _getNextDateForDay(adjustedNow, nextDay, alarm.time);
        return alarm.copyWith(time: nextAlarmTime, id: alarm.id + nextDay);
      }
    } else {
      // If today is not in alarm.days, find the next valid day
      final nextDay = _getNextDay(alarm.days, adjustedNow.weekday);
      final nextAlarmTime =
          _getNextDateForDay(adjustedNow, nextDay, alarm.time);
      return alarm.copyWith(time: nextAlarmTime, id: alarm.id + nextDay);
    }
    return alarm; // Return unchanged if no adjustments are needed
  }

  int _getNextDay(List<int> days, int currentDay) {
    return days.firstWhere((day) => day > currentDay, orElse: () => days.first);
  }

  DateTime _getNextDateForDay(DateTime now, int targetWeekday, DateTime time) {
    final daysUntilTarget = (targetWeekday - now.weekday + 7) % 7;
    final nextDate = now.add(Duration(days: daysUntilTarget));
    return DateTime(
        nextDate.year, nextDate.month, nextDate.day, time.hour, time.minute);
  }
}

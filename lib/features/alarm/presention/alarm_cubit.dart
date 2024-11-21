import 'package:flutter_bloc/flutter_bloc.dart';
import '../../alarm/domain/models/alarm.dart';
import '../data/repository/alarm_native_repo.dart';
import '../../main/presention/main_cubit.dart';
import '../domain/repository/alarm_repo.dart';

class AlarmCubit extends Cubit<List<Alarm>> {
  final AlarmRepo alarmRepo;
  final AlarmNativeRepo alarmNativeRepo;
  final MainCubit mainCubit;

  AlarmCubit(this.alarmRepo, this.alarmNativeRepo, this.mainCubit) : super([]) {
    loadAlarms();
  }

  Future<void> loadAlarms() async {
    final alarms = await alarmRepo.getAlarms();
    alarms.sort((a, b) => a.id.compareTo(b.id));
    emit(alarms);
  }

  Future<void> addAlarm(Alarm alarm) async {
    final now = DateTime.now();
    await alarmRepo.addAlarm(alarm);

    if (alarm.days.isEmpty || alarm.days.contains(now.weekday)) {
      await alarmNativeRepo.addAlarm(alarm);
    } else {
      final nextDay = _getNextDay(alarm.days, now.weekday);
      final nextAlarmTime = _getNextDateForDay(now, nextDay, alarm.time);
      final adjustedAlarm =
          alarm.copyWith(time: nextAlarmTime, id: alarm.id + nextDay);
      await alarmNativeRepo.addAlarm(adjustedAlarm);
    }
    loadAlarms();
  }

  Future<void> removeAlarm(Alarm alarm) async {
    await alarmRepo.removeAlarm(alarm);
    await alarmNativeRepo.removeAlarm(alarm.id);
    loadAlarms();
  }

  Future<void> updateAlarm(Alarm alarm) async {
    final now = DateTime.now();

    // Update the alarm in persistent storage
    await alarmRepo.updateAlarm(alarm);

    // Reschedule the alarm based on the `days` list
    if (alarm.days.isEmpty || alarm.days.contains(now.weekday)) {
      // Schedule immediately
      await alarmNativeRepo.updateAlarm(alarm);
    } else {
      // Schedule for the next day in the list
      final nextDay = _getNextDay(alarm.days, now.weekday);
      final nextAlarmTime = _getNextDateForDay(now, nextDay, alarm.time);
      final adjustedAlarm =
          alarm.copyWith(time: nextAlarmTime, id: alarm.id + nextDay);
      await alarmNativeRepo.updateAlarm(adjustedAlarm);
    }

    // Reload alarms
    loadAlarms();
  }

  Future<void> toggleAlarmActive(Alarm alarm) async {
    final updatedAlarm = alarm.toggleActive();
    await updateAlarm(updatedAlarm); // Reuse the updated logic
  }

  Future<void> stopAlarm(int id) async {
    final alarm = await alarmRepo.getAlarm(id);
    await alarmNativeRepo.removeAlarm(id);

    if (alarm.days.isNotEmpty) {
      final now = DateTime.now();
      final nextDay = _getNextDay(alarm.days, now.weekday);
      final nextAlarmTime = _getNextDateForDay(now, nextDay, alarm.time);
      final adjustedAlarm =
          alarm.copyWith(time: nextAlarmTime, id: alarm.id + nextDay);
      await alarmNativeRepo.addAlarm(adjustedAlarm);
    }

    mainCubit.checkAuthentication(true);
    loadAlarms();
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

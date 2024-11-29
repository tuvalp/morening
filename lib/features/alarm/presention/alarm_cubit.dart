import 'package:flutter_bloc/flutter_bloc.dart';
import '../../alarm/domain/models/alarm.dart';
import '../data/repository/alarm_native_repo.dart';
import '../../main/presention/main_cubit.dart';
import '../domain/repository/alarm_repo.dart';
import 'alarm_state.dart';

class AlarmCubit extends Cubit<AlarmState> {
  final AlarmRepo alarmRepo;
  final AlarmNativeRepo alarmNativeRepo;
  final MainCubit mainCubit;

  AlarmCubit(this.alarmRepo, this.alarmNativeRepo, this.mainCubit)
      : super(AlarmInitial()) {
    loadAlarms();
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

  Future<void> addAlarm(Alarm alarm) async {
    try {
      emit(AlarmLoading());
      final now = DateTime.now();
      final adjustedAlarm = await _getAdjustedAlarm(alarm, now);

      await alarmRepo.addAlarm(alarm);
      await alarmNativeRepo.addAlarm(adjustedAlarm);

      loadAlarms();
    } catch (error) {
      emit(AlarmError('Failed to add alarm: $error'));
    }
  }

  Future<void> removeAlarm(Alarm alarm) async {
    try {
      emit(AlarmLoading());
      await alarmRepo.removeAlarm(alarm);
      await alarmNativeRepo.removeAlarm(alarm.id);
      loadAlarms();
    } catch (error) {
      emit(AlarmError('Failed to remove alarm: $error'));
    }
  }

  Future<void> updateAlarm(Alarm alarm) async {
    try {
      emit(AlarmLoading());
      final now = DateTime.now();
      final adjustedAlarm = await _getAdjustedAlarm(alarm, now);

      await alarmRepo.updateAlarm(alarm);
      await alarmNativeRepo.updateAlarm(adjustedAlarm);

      loadAlarms();
    } catch (error) {
      emit(AlarmError('Failed to update alarm: $error'));
    }
  }

  Future<void> toggleAlarmActive(Alarm alarm) async {
    try {
      final updatedAlarm = alarm.toggleActive();
      await updateAlarm(updatedAlarm);
    } catch (error) {
      emit(AlarmError('Failed to toggle alarm: $error'));
    }
  }

  Future<void> stopAlarm(int id) async {
    try {
      emit(AlarmLoading());
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

      mainCubit.checkAuthentication(true);
      loadAlarms();
    } catch (error) {
      emit(AlarmError('Failed to stop alarm: $error'));
    }
  }

  Future<Alarm> _getAdjustedAlarm(Alarm alarm, DateTime now) async {
    if (alarm.days.isEmpty) {
      // If no days are specified, schedule for tomorrow if time has passed
      final nextAlarmTime = alarm.time.isBefore(now)
          ? alarm.time.add(Duration(days: 1))
          : alarm.time;
      return alarm.copyWith(time: nextAlarmTime);
    } else if (alarm.days.contains(now.weekday)) {
      // If today is in the alarm days, but the time has passed
      if (alarm.time.isBefore(now)) {
        final nextDay = _getNextDay(alarm.days, now.weekday);
        final nextAlarmTime = _getNextDateForDay(now, nextDay, alarm.time);
        return alarm.copyWith(time: nextAlarmTime, id: alarm.id + nextDay);
      }
    } else {
      // If today is not in alarm.days, find the next valid day
      final nextDay = _getNextDay(alarm.days, now.weekday);
      final nextAlarmTime = _getNextDateForDay(now, nextDay, alarm.time);
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

import '../domain/models/alarm.dart';

abstract class AlarmState {
  const AlarmState();
}

class AlarmInitial extends AlarmState {
  const AlarmInitial([List<Alarm>? alarms]) : super();
}

class AlarmLoading extends AlarmState {}

class AlarmLoaded extends AlarmState {
  final List<Alarm> alarms;

  const AlarmLoaded(this.alarms);
}

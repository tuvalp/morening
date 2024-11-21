import 'package:alarm/model/alarm_settings.dart';

import '../domain/models/route.dart';

abstract class MainState {
  const MainState();
}

class MainInitial extends MainState {
  const MainInitial();
}

class AlarmRingingState extends MainState {
  final AlarmSettings alarm;

  const AlarmRingingState(this.alarm);
}

class AuthenticatedState extends MainState {
  final MainRoute screen;

  const AuthenticatedState(this.screen);
}

class UnauthenticatedState extends MainState {}

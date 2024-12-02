import 'package:alarm/model/alarm_settings.dart';

import '../domain/models/route.dart';

abstract class MainState {
  const MainState();
}

class MainInitial extends MainState {
  const MainInitial();
}

class MainLoading extends MainState {
  const MainLoading();
}

class AlarmRingingState extends MainState {
  final AlarmSettings alarm;

  const AlarmRingingState(this.alarm);
}

class AuthenticatedState extends MainState {
  final MainRoute screen;
  final String? userId;

  const AuthenticatedState(this.screen, this.userId);
}

class UnauthenticatedState extends MainState {}

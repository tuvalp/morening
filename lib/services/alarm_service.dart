import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/alarm/presention/alarm_cubit.dart';

class AlarmService {
  final BuildContext context;
  StreamSubscription<AlarmSettings>? _ringSubscription;
  static final _broadcastStream = Alarm.ringStream.stream.asBroadcastStream();

  AlarmService(this.context);

  Future<void> initialize() async {
    _ringSubscription?.cancel();
    _ringSubscription = _broadcastStream.listen((alarm) {
      context.read<AlarmCubit>().onAlarmRing(alarm);
    });
  }

  void dispose() {
    _ringSubscription?.cancel();
    _ringSubscription = null;
  }
}

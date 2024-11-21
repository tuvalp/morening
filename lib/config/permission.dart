import 'dart:async';

import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  void requestPermission() async {
    await checkAndroidScheduleExactAlarmPermission();
    await initAutoStart();
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    print('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      print('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      print(
          'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
    }
  }

  Future<void> initAutoStart() async {
    try {
      //check auto-start availability.
      var test = await (isAutoStartAvailable as FutureOr<bool>);
      print(test);
      //if available then navigate to auto-start setting page.
      if (test) await getAutoStartPermission();
    } on PlatformException catch (e) {
      print(e);
    }
  }
}

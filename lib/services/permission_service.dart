import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> checkPermissions() async {
    await checkNotificationPermission();
    if (Alarm.android) {
      await checkAndroidScheduleExactAlarmPermission();
    }
  }

  static Future<void> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  static Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  static Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }

    final autoStart = await Permission.criticalAlerts.status;
    alarmPrint('Critical alerts permission: $autoStart.');
    if (autoStart.isDenied) {
      alarmPrint('Requesting critical alerts permission...');
      final res = await Permission.criticalAlerts.request();
      alarmPrint(
        'Critical alerts permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }
}

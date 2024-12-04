import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:autostarter/autostarter.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissions {
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
  }

  static Future<void> getAutoStartPermission() async {
    try {
      // Check if AutoStart permission feature is available on the device
      bool? isAvailable = await Autostarter.isAutoStartPermissionAvailable();
      if (isAvailable == true) {
        // Check the AutoStart permission state
        bool? status = await Autostarter.checkAutoStartState();
        if (status == null) {
          // Handle null status if needed
        } else {
          if (status == false) {
            // Request AutoStart permission if it is not enabled
            await Autostarter.getAutoStartPermission(newTask: true);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

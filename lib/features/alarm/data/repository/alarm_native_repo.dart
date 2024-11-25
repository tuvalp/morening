import 'dart:io';
import '../../domain/models/alarm.dart' as alarm_obj;
import 'package:alarm/alarm.dart';

class AlarmNativeRepo {
  Future<void> addAlarm(alarm_obj.Alarm alarm) async {
    final settings = AlarmSettings(
      id: alarm.id,
      dateTime: alarm.time,
      assetAudioPath: "assets/ringtones/${alarm.ringtone}.mp3",
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      warningNotificationOnKill: Platform.isIOS,
      notificationSettings: NotificationSettings(
        title: "${alarm.time}",
        body: alarm.label,
        stopButton: "Stop",
        icon: 'notification_icon',
      ),
    );
    try {
      await Alarm.set(alarmSettings: settings);
    } catch (e) {
      print('Failed to set alarm: $e');
    }
  }

  Future<void> removeAlarm(int alarmId) async {
/*************  ✨ Codeium Command ⭐  *************/
    /// Removes an alarm with the given ID.
    ///
    /// Throws a [PlatformException] if the underlying platform does not support
    /// removing alarms.
/******  e115d45d-837a-476c-b87d-c952196451fe  *******/ await Alarm.stop(
        alarmId);
  }

  Future<void> updateAlarm(alarm_obj.Alarm alarm) async {
    await removeAlarm(alarm.id);
    if (alarm.isActive) {
      await addAlarm(alarm);
    }
  }
}

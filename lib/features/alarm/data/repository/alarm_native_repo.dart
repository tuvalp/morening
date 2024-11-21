import 'dart:io';
import '../../domain/models/alarm.dart';
import 'package:alarm/alarm.dart' as alarmNative;

class AlarmNativeRepo {
  Future<void> addAlarm(Alarm alarm) async {
    final settings = alarmNative.AlarmSettings(
      id: alarm.id,
      dateTime: alarm.time,
      assetAudioPath: "assets/ringtones/${alarm.ringtone}.mp3",
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      warningNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
      notificationSettings: alarmNative.NotificationSettings(
        title: "${alarm.time}",
        body: alarm.label,
        stopButton: "Stop",
        icon: 'notification_icon',
      ),
    );
    await alarmNative.Alarm.set(alarmSettings: settings);
  }

  Future<void> removeAlarm(int alarmId) async {
    await alarmNative.Alarm.stop(alarmId);
  }

  Future<void> updateAlarm(Alarm alarm) async {
    await removeAlarm(alarm.id);
    await addAlarm(alarm);
  }
}

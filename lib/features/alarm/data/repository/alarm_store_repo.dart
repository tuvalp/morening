import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../alarm/domain/models/alarm.dart';
import '../../../alarm/domain/repository/alarm_repo.dart';

class AlarmStoreRepo implements AlarmRepo {
  @override
  Future<List<Alarm>> getAlarms() {
    final perf = SharedPreferences.getInstance();

    return perf.then((prefs) {
      final String? alarmsJson = prefs.getString('alarms');
      if (alarmsJson != null) {
        final List<dynamic> alarmList = jsonDecode(alarmsJson);
        return alarmList.map((alarm) => Alarm.fromJson(alarm)).toList();
      } else {
        return [];
      }
    });
  }

  @override
  Future<Alarm> getAlarm(int id) {
    final perf = SharedPreferences.getInstance();

    return perf.then((prefs) {
      final String? alarmsJson = prefs.getString('alarms');
      if (alarmsJson != null) {
        final List<dynamic> alarmList = jsonDecode(alarmsJson);
        final alarm = alarmList.firstWhere((element) => element['id'] == id);
        return Alarm.fromJson(alarm);
      } else {
        throw Exception('Alarm not found');
      }
    });
  }

  @override
  Future<void> addAlarm(Alarm alarm) {
    final perf = SharedPreferences.getInstance();

    return perf.then((prefs) {
      final String? alarmsJson = prefs.getString('alarms');
      if (alarmsJson != null) {
        final List<dynamic> alarmList = jsonDecode(alarmsJson);
        alarmList.add(alarm.toJson());
        prefs.setString('alarms', jsonEncode(alarmList));
      } else {
        prefs.setString('alarms', jsonEncode([alarm.toJson()]));
      }
    });
  }

  @override
  Future<void> removeAlarm(Alarm alarm) {
    final perf = SharedPreferences.getInstance();

    return perf.then((prefs) {
      final String? alarmsJson = prefs.getString('alarms');
      if (alarmsJson != null) {
        final List<dynamic> alarmList = jsonDecode(alarmsJson);
        alarmList.removeWhere((element) => element['id'] == alarm.id);
        prefs.setString('alarms', jsonEncode(alarmList));
      }
    });
  }

  @override
  Future<void> updateAlarm(Alarm alarm) {
    final perf = SharedPreferences.getInstance();

    return perf.then((prefs) {
      final String? alarmsJson = prefs.getString('alarms');
      if (alarmsJson != null) {
        final List<dynamic> alarmList = jsonDecode(alarmsJson);
        alarmList.removeWhere((element) => element['id'] == alarm.id);
        alarmList.add(alarm.toJson());
        prefs.setString('alarms', jsonEncode(alarmList));
      }
    });
  }

  @override
  Future<void> stopAlarm(Alarm alarm) {
    // TODO: implement stopAlarm
    throw UnimplementedError();
  }
}

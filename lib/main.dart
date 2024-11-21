import 'package:flutter/material.dart';
import '../app.dart';
import 'package:alarm/alarm.dart' as alarmNative;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await alarmNative.Alarm.init();
  runApp(MyApp());
}

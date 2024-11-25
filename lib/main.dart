import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app.dart';
import 'package:alarm/alarm.dart' as alarmNative;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await alarmNative.Alarm.init();
  runApp(MyApp());
}

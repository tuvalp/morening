import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app.dart';
import 'package:alarm/alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0XFFF6F6F6), // Navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.light, // Light icons for dark backgrounds
    ),
  );

  await Alarm.init();
  runApp(const MyApp());
}

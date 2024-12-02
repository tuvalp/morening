import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/cognito_config.dart';
import '../app.dart';
import 'package:alarm/alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0XFFFAFAFA), // Navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.light, // Light icons for dark backgrounds
    ),
  );

  await Alarm.init();
  await CognitoConfig().configureAmplify();

  runApp(const MyApp());
}

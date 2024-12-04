import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alarm/alarm.dart';

import 'config/cognito_config.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0XFFFAFAFA),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await Alarm.init();
  await CognitoConfig().configureAmplify();

  runApp(const MyApp());
}

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/cognito_config.dart';

import 'services/navigation_service.dart';
import 'theme/theme.dart';

import 'features/auth/data/auth_api_repo.dart';
import 'features/auth/data/auth_cognito_repo.dart';
import 'features/auth/presention/auth_cubit.dart';

import 'features/main/presention/main_cubit.dart';

import 'features/alarm/data/repository/alarm_native_repo.dart';
import 'features/alarm/data/repository/alarm_store_repo.dart';
import 'features/alarm/presention/alarm_cubit.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) =>
              AuthCubit(AuthCognitoRepo(), AuthApiRepo())..getCurrentUser(),
          lazy: false,
        ),
        BlocProvider<MainCubit>(
          create: (context) => MainCubit(context.read<AuthCubit>()),
          lazy: false,
        ),
        BlocProvider<AlarmCubit>(
          create: (context) => AlarmCubit(
              AlarmStoreRepo(), AlarmNativeRepo(), context.read<MainCubit>()),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'MoreNing',
        theme: theme(),
        home: const AppView(),
      ),
    );
  }
}

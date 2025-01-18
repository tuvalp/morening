import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/device/presention/device_cubit.dart';
import '/features/alarm/presention/page/alarm_ring.dart';
import '/services/alarm_service.dart';
import '/utils/snackbar_extension.dart';
import 'config/cognito_config.dart';

import 'features/alarm/data/repository/alarm_api_repo.dart';
import 'features/alarm/presention/alarm_state.dart';

import 'features/auth/presention/auth_state.dart';
import 'features/auth/presention/page/login_screen.dart';
import 'features/profile/data/settings_repo.dart';
import 'features/profile/domain/models/settings.dart';
import 'features/profile/presention/porfile_cubit.dart';
import 'services/navigation_service.dart';
import 'theme/theme.dart';

import 'features/auth/data/auth_api_repo.dart';
import 'features/auth/data/auth_cognito_repo.dart';
import 'features/auth/presention/auth_cubit.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AlarmService(context).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit(AuthCognitoRepo(), AuthApiRepo());

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => authCubit..isAuthenticated(),
        ),
        BlocProvider<AlarmCubit>(
          create: (context) =>
              AlarmCubit(AlarmStoreRepo(), AlarmNativeRepo(), AlarmApiRepo()),
          lazy: false,
        ),
        BlocProvider<DeviceCubit>(
          create: (_) => DeviceCubit(authCubit),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(SettingsRepoImpl()),
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return BlocListener<AlarmCubit, AlarmState>(
            listener: (context, state) {
              if (state is AlarmRingingState) {
                NavigationService.navigateTo(AlarmRingView(alarm: state.alarm));
              }
              if (state is AlarmError) {
                context.showErrorSnackBar(state.message);
              }
            },
            child: BlocBuilder<ProfileCubit, Settings>(
              builder: (context, settings) {
                return MaterialApp(
                  navigatorKey: NavigationService.navigatorKey,
                  debugShowCheckedModeBanner: false,
                  title: 'WakeyAI',
                  theme: AppTheme.getTheme(context),
                  home: authState is AuthLoading
                      ? const SplashScreen()
                      : authState is Unauthenticated
                          ? const LoginScreen()
                          : const AppView(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage("assets/logo/logo.png"),
          height: 150,
        ),
      ),
    );
  }
}

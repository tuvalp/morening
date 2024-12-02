import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/config/permission.dart';
import 'package:morening_2/features/main/presention/main_view.dart';
import 'package:morening_2/theme/theme.dart';
import '../features/alarm/data/repository/alarm_store_repo.dart';
import '../features/alarm/presention/alarm_cubit.dart';
import 'features/alarm/data/repository/alarm_native_repo.dart';
import 'features/alarm/presention/alarm_state.dart';
import 'features/alarm/presention/page/alarm_ring.dart';
import 'features/auth/data/auth_cognito_repo.dart';
import 'features/auth/presention/auth_cubit.dart';
import 'features/auth/presention/auth_state.dart';
import 'features/auth/presention/page/login_screen.dart';
import 'features/main/presention/main_cubit.dart';
import 'features/main/presention/main_state.dart';
import 'features/plan/data/repository/plan_api_repo.dart';
import 'features/plan/presention/plan_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit(AuthCubit(AuthCognitoRepo())),
        ),
        BlocProvider(
          create: (context) => AuthCubit(AuthCognitoRepo())..getCurrentUser(),
        ),
        BlocProvider(
          create: (context) => AlarmCubit(
            AlarmStoreRepo(),
            AlarmNativeRepo(),
            context.read<MainCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => PlanCubit(
            PlanApiRepo(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MoreNing',
        theme: theme(),
        home: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  static StreamSubscription<AlarmSettings>? ringSubscription;

  @override
  void initState() {
    super.initState();

    AlarmPermissions.checkNotificationPermission();
    if (Alarm.android) {
      AlarmPermissions.checkAndroidScheduleExactAlarmPermission();
    }

    ringSubscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
  }

  Future<void> navigateToRingScreen(AlarmSettings alarm) async {
    context.read<AlarmCubit>().onAlarmRing(alarm);
  }

  @override
  void dispose() {
    ringSubscription?.cancel();
    ringSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlarmCubit, AlarmState>(
      builder: (context, state) {
        if (state is AlarmRingingState) {
          return AlarmRingView(alarm: state.alarm);
        } else {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                // Main View
                return BlocBuilder<MainCubit, MainState>(
                  builder: (context, state) {
                    if (state is MainLoad) {
                      return MainView(screen: state.screen);
                    } else {
                      return const LoginScreen();
                    }
                  },
                );
              } else if (state is Unauthenticated) {
                // Auth view
                return const LoginScreen();
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        }
      },
    );

    // return BlocBuilder<MainCubit, MainState>(
    //   builder: (context, state) {
    //     if (state is AuthenticatedState) {
    //       // Main View
    //       return MainView(screen: state.screen);
    //     } else if (state is AlarmRingingState) {
    //       // Alarm Ring
    //       return AlarmRingView(alarm: state.alarm);
    //     } else if (state is UnauthenticatedState) {
    //       // Auth view
    //       return const LoginScreen();
    //     } else {
    //       return const Scaffold(
    //         body: Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       );
    //     }
    //   },
    //);
  }
}

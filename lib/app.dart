import 'dart:async';
import 'package:flutter/material.dart';

import 'package:alarm/alarm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/auth/data/auth_api_repo.dart';

import '/config/permission.dart';
import '/theme/theme.dart';
import 'utils/format.dart';

import 'features/main/presention/main_view.dart';
import 'features/main/presention/main_cubit.dart';
import 'features/main/presention/main_state.dart';

import 'features/alarm/presention/alarm_cubit.dart';
import 'features/alarm/presention/alarm_state.dart';
import 'features/alarm/presention/page/alarm_ring.dart';
import 'features/alarm/data/repository/alarm_native_repo.dart';
import 'features/alarm/data/repository/alarm_store_repo.dart';

import 'features/auth/presention/auth_cubit.dart';
import 'features/auth/presention/auth_state.dart';
import 'features/auth/data/auth_cognito_repo.dart';
import 'features/auth/presention/page/login_screen.dart';

import 'features/plan/presention/plan_cubit.dart';
import 'features/plan/data/repository/plan_api_repo.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit(AuthCognitoRepo(), AuthApiRepo())..getCurrentUser(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => MainCubit(context.read<AuthCubit>()),
                ),
                BlocProvider(
                  create: (context) =>
                      PlanCubit(PlanApiRepo(), state.user.id)..loadPlan(),
                ),
                BlocProvider(
                  create: (context) => AlarmCubit(
                    AlarmStoreRepo(),
                    AlarmNativeRepo(),
                    context.read<MainCubit>(),
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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MoreNing',
            theme: theme(),
            home: const LoginScreen(),
          );
        },
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
  static final _alarmStream = Alarm.ringStream.stream.asBroadcastStream();

  @override
  void initState() {
    super.initState();

    AlarmPermissions.checkNotificationPermission();
    if (Alarm.android) {
      AlarmPermissions.checkAndroidScheduleExactAlarmPermission();
    }

    ringSubscription = _alarmStream.listen((alarm) {
      if (!mounted) return;
      context.read<AlarmCubit>().onAlarmRing(alarm);
    });
  }

  @override
  void dispose() {
    ringSubscription?.cancel();
    ringSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AlarmCubit, AlarmState>(
          listener: (context, state) {
            if (state is AlarmRingingState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlarmRingView(alarm: state.alarm),
                ),
              );
            } else if (state is AlarmError) {
              showSnackBar(context, state.message);
              if (context.read<AuthCubit>().state is Authenticated) {
                context.read<MainCubit>().resetMainView();
              }
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated || state is AuthError) {
              if (state is AuthError) {
                showSnackBar(context, state.error);
              }
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          return state is MainLoad
              ? MainView(screen: state.screen)
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

showSnackBar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(Format.extractMessage(message)),
    ),
  );
}

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:alarm/alarm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    AlarmPermissions.initAutoStart();

    ringSubscription = Alarm.ringStream.stream.listen((alarm) {
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
    return BlocListener<AlarmCubit, AlarmState>(
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
          context.read<MainCubit>().resetMainView();
        }
      },
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.read<MainCubit>().loadMainView();
          } else if (state is Unauthenticated) {
            context.read<MainCubit>().resetMainView();
          } else if (state is AuthError) {
            showSnackBar(context, state.error);
            context.read<MainCubit>().resetMainView();
          }
        },
        builder: (context, state) {
          if (state is AuthInitial) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is Authenticated) {
            return BlocBuilder<MainCubit, MainState>(
              builder: (context, mainState) {
                if (mainState is MainLoad) {
                  return MainView(screen: mainState.screen);
                } else {
                  return const LoginScreen();
                }
              },
            );
          } else if (state is Unauthenticated) {
            return const LoginScreen();
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
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

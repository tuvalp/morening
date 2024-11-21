import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/config/permission.dart';
import 'package:morening_2/features/main/presention/main_view.dart';
import 'package:morening_2/theme/theme.dart';
import '../features/alarm/data/repository/alarm_store_repo.dart';
import '../features/alarm/presention/alarm_cubit.dart';
import 'features/alarm/data/repository/alarm_native_repo.dart';
import 'features/alarm/presention/page/alarm_ring.dart';
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
          create: (context) => MainCubit(),
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
        title: 'Flutter Demo',
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
  @override
  void initState() {
    super.initState();

    AppPermission().requestPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Alarm.ringStream.stream.listen((alarmSettings) {
        context.read<MainCubit>().onAlarmRing(alarmSettings);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        if (state is AuthenticatedState) {
          // Main View
          return MainView(screen: state.screen);
        } else if (state is AlarmRingingState) {
          // Alarm Ring
          return AlarmRingView(alarm: state.alarm);
        } else if (state is UnauthenticatedState) {
          // Auth view
          return const Scaffold(
            body: Center(
              child: Text("Not Authenticated"),
            ),
          );
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
}

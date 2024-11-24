import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/main/domain/models/route.dart';

import 'components/main_app_bar.dart';
import 'components/main_bottom_bar.dart';
import 'main_cubit.dart';

class MainView extends StatefulWidget {
  final MainRoute screen;
  const MainView({required this.screen, super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  static StreamSubscription<AlarmSettings>? ringSubscription;
  static StreamSubscription<int>? updateSubscription;

  @override
  void initState() {
    super.initState();
    ringSubscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
    updateSubscription ??= Alarm.updateStream.stream.listen((_) {
      print("Alarm updated");
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarm) async {
    print("Navigating to ring screen");
    context.read<MainCubit>().onAlarmRing(alarm);
  }

  @override
  void dispose() {
    ringSubscription?.cancel();
    updateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: widget.screen.title,
      ),
      body: widget.screen.widget,
      bottomNavigationBar: const MainBottomNavBar(),
    );
  }
}

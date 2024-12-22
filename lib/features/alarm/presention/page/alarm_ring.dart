import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/utils/format.dart';
import '../../../../app.dart';
import '../../../../services/navigation_service.dart';
import '../alarm_cubit.dart';
import '../components/swipe_up.dart';

class AlarmRingView extends StatelessWidget {
  final AlarmSettings alarm;
  const AlarmRingView({required this.alarm, super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> stopAlarm() async {
      context.read<AlarmCubit>().stopAlarm(alarm.id);
      NavigationService.navigateTo(const AppView());
    }

    Future<void> snoozeAlarm() async {
      context.read<AlarmCubit>().snoozeAlarm(alarm.id);
      NavigationService.navigateTo(const AppView());
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 32),
            Column(
              children: [
                Text(DateFormat('EEEE, dd MMM, yyyy').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSecondary,
                    )),
                Text(
                  Format.formatAlarmTime(alarm.dateTime),
                  style: TextStyle(
                    fontSize: 86,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  alarm.notificationSettings.body,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: snoozeAlarm,
              child: Container(
                padding: const EdgeInsets.all(52),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  "Snooze",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: SwipeUp(onSwipeUp: stopAlarm),
            ),
          ],
        ),
      ),
    );
  }
}

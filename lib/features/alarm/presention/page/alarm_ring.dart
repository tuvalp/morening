import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/utils/format.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../alarm_cubit.dart';
import '../alarm_state.dart';

class AlarmRingView extends StatelessWidget {
  final AlarmSettings alarm;
  const AlarmRingView({required this.alarm, super.key});

  @override
  Widget build(BuildContext context) {
    final alarms = context.read<AlarmCubit>().state as AlarmRingingState;
    final alarm = alarms.alarm;

    Future<void> stopAlarm() async {
      context.read<AlarmCubit>().stopAlarm(alarm.id);
      Navigator.pop(context);
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
                      color: Theme.of(context).colorScheme.tertiary,
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
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => context.read<AlarmCubit>().snoozeAlarm(alarm.id),
              child: Container(
                padding: const EdgeInsets.all(52),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: SlideAction(
                sliderRotate: false,
                elevation: 0,
                outerColor: Theme.of(context).colorScheme.onSurfaceVariant,
                innerColor: Theme.of(context).colorScheme.primary,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                text: "Stop",
                onSubmit: stopAlarm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

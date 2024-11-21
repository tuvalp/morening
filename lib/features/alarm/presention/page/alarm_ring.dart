import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/main/presention/main_cubit.dart';
import 'package:morening_2/utils/format.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../../../main/presention/main_state.dart';
import '../alarm_cubit.dart';
import '../components/animated_bell.dart';

class AlarmRingView extends StatelessWidget {
  final AlarmSettings alarm;
  const AlarmRingView({required this.alarm, super.key});

  @override
  Widget build(BuildContext context) {
    final alarms = context.read<MainCubit>().state as AlarmRingingState;
    final alarm = alarms.alarm;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const AnimatedBell(),
                Text(
                  Format.formatAlarmTime(alarm.dateTime),
                  style: TextStyle(
                    fontSize: 92,
                    fontWeight: FontWeight.w200,
                    color: Theme.of(context).colorScheme.primary,
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
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(42),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  "Snooze",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SlideAction(
                sliderRotate: false,
                elevation: 1,
                outerColor: Theme.of(context).colorScheme.tertiary,
                innerColor: Theme.of(context).colorScheme.primary,
                textColor: Colors.red,
                text: "Stop",
                onSubmit: () => context.read<AlarmCubit>().stopAlarm(alarm.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

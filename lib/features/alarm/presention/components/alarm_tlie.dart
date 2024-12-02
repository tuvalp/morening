import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../features/alarm/presention/alarm_cubit.dart';
import '../../../../features/alarm/presention/page/add_edit_alarm_view.dart';
import '../../../../utils/format.dart';
import '../../domain/models/alarm.dart';

class AlarmTile extends StatelessWidget {
  final Alarm alarm;

  const AlarmTile({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          elevation: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Format.formatAlarmTime(alarm.time),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    alarm.label == ''
                        ? Format.formatPlanLabel(alarm.planId)
                        : "${alarm.label} | ${Format.formatPlanLabel(alarm.planId)}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CupertinoSwitch(
                activeColor: Theme.of(context).colorScheme.primary,
                value: alarm.isActive,
                onChanged: (value) {
                  final AlarmCubit alarmRepo = context.read<AlarmCubit>();
                  alarmRepo.toggleAlarmActive(alarm);
                },
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditAlarmView(alarm: alarm),
            ),
          );
        });
  }
}

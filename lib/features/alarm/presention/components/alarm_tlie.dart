import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../features/alarm/presention/alarm_cubit.dart';
import '../../../../features/alarm/presention/page/add_edit_alarm_view.dart';
import 'package:provider/provider.dart';

// Models
import '../../../../utils/format.dart';
import '../../domain/models/alarm.dart';

class AlarmTile extends StatelessWidget {
  final Alarm alarm;

  const AlarmTile({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(Format.formatAlarmTime(alarm.time),
          style: const TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 42,
              letterSpacing: 1,
              color: Colors.white)),
      subtitle: alarm.label == ''
          ? Text(alarm.planId,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary, fontSize: 14))
          : Text("${alarm.label} | ${Format.formatPlanLabel(alarm.planId)}",
              style: const TextStyle(color: Colors.white60, fontSize: 14)),
      trailing: CupertinoSwitch(
        value: alarm.isActive,
        onChanged: (value) {
          final AlarmCubit alarmRepo = context.read<AlarmCubit>();

          alarmRepo.toggleAlarmActive(alarm);
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditAlarmView(alarm: alarm),
          ),
        );
      },
    );
  }
}

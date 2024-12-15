import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      onTap: () => _navigateToEditAlarm(context),
      child: Card(
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAlarmDetails(context),
            const Spacer(),
            _buildAlarmSwitch(context),
          ],
        ),
      ),
    );
  }

  /// Builds the alarm time and label display.
  Widget _buildAlarmDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Format.formatAlarmTime(alarm.time),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        alarm.label.isEmpty
            ? Text(
                alarm.label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )
            : Container(),
      ],
    );
  }

  /// Builds the CupertinoSwitch for toggling the alarm.
  Widget _buildAlarmSwitch(BuildContext context) {
    return CupertinoSwitch(
      activeColor: Theme.of(context).colorScheme.primary,
      value: alarm.isActive,
      onChanged: (value) {
        _toggleAlarm(context, value);
      },
    );
  }

  /// Toggles the alarm's active state using AlarmCubit.
  void _toggleAlarm(BuildContext context, bool value) {
    final alarmCubit = context.read<AlarmCubit>();
    alarmCubit.toggleAlarmActive(alarm);
  }

  /// Navigates to the Add/Edit Alarm screen.
  void _navigateToEditAlarm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAlarmView(alarm: alarm),
      ),
    );
  }
}

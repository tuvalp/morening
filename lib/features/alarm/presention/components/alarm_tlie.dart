import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/auth/presention/auth_cubit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../features/alarm/presention/alarm_cubit.dart';
import '../../../../features/alarm/presention/page/add_edit_alarm_view.dart';
import '../../../../utils/format.dart';
import '../../../auth/presention/auth_state.dart';
import '../../domain/models/alarm.dart';

class AlarmTile extends StatelessWidget {
  final Alarm alarm;

  const AlarmTile({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                color: Theme.of(context).colorScheme.error,
              ),
              child: IconButton(
                  onPressed: () => () {},
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onError,
                  )),
            )
            // SlidableAction(
            //   borderRadius: BorderRadius.only(
            //     topRight: Radius.circular(16),
            //     bottomRight: Radius.circular(16),
            //   ),
            //   backgroundColor: Theme.of(context).colorScheme.error,
            //   icon: Icons.delete,
            //   foregroundColor: Theme.of(context).colorScheme.onError,
            //   label: 'Delete',
            //   onPressed: (context) {
            //     final alarmCubit = context.read<AlarmCubit>();
            //     final authCubit =
            //         context.read<AuthCubit>().state as Authenticated;
            //     alarmCubit.removeAlarm(alarm, authCubit.user.id);
            //   },
            // ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () => _navigateToEditAlarm(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAlarmDetails(context),
                const Spacer(),
                _buildAlarmSwitch(context),
              ],
            ),
          ),
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
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: alarm.isActive
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        Text(
          alarm.label.isNotEmpty ? alarm.label : "alarm",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: alarm.isActive
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onTertiary,
          ),
        )
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
    final authCubit = context.read<AuthCubit>().state as Authenticated;
    alarmCubit.toggleAlarmActive(alarm, authCubit.user.id);
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

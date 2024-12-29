import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morening_2/features/auth/presention/auth_state.dart';

import '../../../../services/navigation_service.dart';
import '../../../auth/presention/auth_cubit.dart';
import '../../presention/alarm_cubit.dart';
import '../../../../utils/ringtone_array.dart';
import '../components/add_edit_alarm_app_bar.dart';
import '../components/time_picker.dart';
import '../../../alarm/domain/models/alarm.dart';
import '../components/repeat_day_picker.dart';
import '../components/ringtone_picker.dart';

class AddEditAlarmView extends StatefulWidget {
  final Alarm? alarm;

  const AddEditAlarmView({this.alarm}) : super(key: null);

  @override
  AddEditAlarmViewState createState() => AddEditAlarmViewState();
}

class AddEditAlarmViewState extends State<AddEditAlarmView> {
  late DateTime _selectedTime;
  late TextEditingController _labelController;
  late List<int> _selectedDays;
  late bool _physicalDevice = false;
  late String _ringtone = "";
  late String _planId = "";

  @override
  void initState() {
    super.initState();

    _selectedTime =
        widget.alarm?.time ?? DateTime.now().add(const Duration(minutes: 1));
    _labelController = TextEditingController(text: widget.alarm?.label ?? '');
    _selectedDays = widget.alarm?.days ?? [];
    _ringtone = widget.alarm?.ringtone ?? RingtoneArray.ringtones.first;

    _planId = widget.alarm?.planId ?? "";
  }

  void _onTimeChanged(DateTime time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void _onDaysChanged(bool add, int index) {
    setState(() {
      if (add) {
        if (!_selectedDays.contains(index)) {
          _selectedDays.add(index);
        }
      } else {
        _selectedDays.remove(index);
      }
    });
  }

  void _onRingtoneChanged(String ringtone) {
    setState(() {
      _ringtone = ringtone;
    });
  }

  void _onPhysicalDeviceChanged(bool value) {
    setState(() {
      _physicalDevice = value;
    });
  }

  void _saveAlarm() {
    final alarmCubit = context.read<AlarmCubit>();
    final authCubit = context.read<AuthCubit>();

    // Check if the user is authenticated
    if (authCubit.state is Authenticated) {
      final userId = (authCubit.state as Authenticated).user.id;

      final Alarm alarm = Alarm(
        id: widget.alarm?.id ?? DateTime.now().millisecondsSinceEpoch % 100000,
        label: _labelController.text,
        time: _selectedTime.copyWith(
          second: 0,
          millisecond: 0,
        ),
        isActive: true,
        days: _selectedDays,
        planId: _planId,
        ringtone: _ringtone,
      );

      if (widget.alarm == null) {
        alarmCubit.addAlarm(alarm, userId);
      } else {
        alarmCubit.updateAlarm(alarm);
      }
      NavigationService.pop();
    }
  }

  void _deleteAlarm() {
    final alarmRepo = context.read<AlarmCubit>();

    alarmRepo.removeAlarm(widget.alarm!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddEditAlarmAppBar(
        title: widget.alarm == null ? 'Add Alarm' : 'Edit Alarm',
        onSave: _saveAlarm,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Center(
                  child: TimePicker(
                    selectedTime: _selectedTime,
                    onTimeChanged: _onTimeChanged,
                  ),
                ),
                const SizedBox(height: 20),
                _buildRow(
                  context: context,
                  child: RepeatDayPicker(
                    selectedDays: _selectedDays,
                    onDaysChanged: _onDaysChanged,
                  ),
                ),
                _buildRow(
                  context: context,
                  title: "Label",
                  child: Flexible(
                    child: TextField(
                      controller: _labelController,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Label",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      cursorColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                _buildRow(
                  context: context,
                  title: "Ringtone",
                  child: RingtonePicker(
                    selectedRingtone: _ringtone,
                    onRingtoneChanged: _onRingtoneChanged,
                  ),
                ),
                _buildRow(
                  context: context,
                  title: "Physical device",
                  child: CupertinoSwitch(
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: _physicalDevice,
                    onChanged: (value) {
                      _onPhysicalDeviceChanged(value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                widget.alarm == null
                    ? const SizedBox.shrink()
                    : _buildRow(
                        context: context,
                        child: TextButton(
                          onPressed: _deleteAlarm,
                          child: Text(
                            "Delete Alarm",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
      {required BuildContext context, String? title, required Widget child}) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: title != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title),
                const Spacer(),
                child,
              ],
            )
          : Center(child: child),
    );
  }
}

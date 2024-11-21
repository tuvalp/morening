import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presention/alarm_cubit.dart';
import '../../../../config/ringtone_array.dart';
import '../../../plan/presention/plan_cubit.dart';
import '../components/add_edit_alarm_app_bar.dart';
import '../components/plans_picker.dart';
import '../components/time_picker.dart';
import '../../../alarm/domain/models/alarm.dart';
import '../components/delete_alarm_button.dart';
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
    final planCubit = context.read<PlanCubit>();
    planCubit.loadPlan();

    _selectedTime =
        widget.alarm?.time ?? DateTime.now().add(const Duration(minutes: 1));
    _labelController = TextEditingController(text: widget.alarm?.label ?? '');
    _selectedDays = widget.alarm?.days ?? [];
    _ringtone = widget.alarm?.ringtone ?? RingtoneArray.ringtones.first;

    _planId = widget.alarm?.planId ?? "";
    if (_planId.isEmpty) {
      final plans = planCubit.state;
      if (plans.isNotEmpty) {
        _planId = plans.first.label;
      }
    }
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

  void _onPlanChanged(String planId) {
    setState(() {
      _planId = planId;
    });
  }

  void _saveAlarm() {
    final alarmRepo = context.read<AlarmCubit>();

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
      alarmRepo.addAlarm(alarm);
    } else {
      alarmRepo.updateAlarm(alarm);
    }
    Navigator.of(context).pop(alarm);
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
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
              children: [
                Center(
                  child: TimePicker(
                    selectedTime: _selectedTime,
                    onTimeChanged: _onTimeChanged,
                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 10),
                RepeatDayPicker(
                  selectedDays: _selectedDays,
                  onDaysChanged: _onDaysChanged,
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    Text(
                      "Label",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: TextField(
                        controller: _labelController,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Label",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        cursorColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Divider(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Wakeup Plan",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    PlansPicker(planId: _planId, onPlanChanged: _onPlanChanged)
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Ringtone",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    RingtonePicker(
                      selectedRingtone: _ringtone,
                      onRingtoneChanged: _onRingtoneChanged,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Physical device",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      activeColor: const Color(0xFF4CAF50),
                      value: _physicalDevice,
                      onChanged: (value) {
                        _onPhysicalDeviceChanged(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            widget.alarm == null
                ? const SizedBox.shrink()
                : DeleteAlarmButton(
                    onDelete: () => _deleteAlarm(),
                  ),
          ],
        ),
      ),
    );
  }
}

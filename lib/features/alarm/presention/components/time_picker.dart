import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final DateTime selectedTime;
  final Function(DateTime) onTimeChanged;

  const TimePicker({
    Key? key,
    required this.selectedTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  TimePickerState createState() => TimePickerState();
}

class TimePickerState extends State<TimePicker> {
  late int selectedHour;
  late int selectedMinute;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.selectedTime.hour;
    selectedMinute = widget.selectedTime.minute;
  }

  void _onHourChanged(int index) {
    setState(() {
      selectedHour = index;
      widget.onTimeChanged(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedHour,
        selectedMinute,
      ));
    });
  }

  void _onMinuteChanged(int index) {
    setState(() {
      selectedMinute = index;
      widget.onTimeChanged(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedHour,
        selectedMinute,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Hour Picker
          SizedBox(
            width: 100,
            child: CupertinoPicker(
              selectionOverlay: Container(),
              looping: true,
              scrollController:
                  FixedExtentScrollController(initialItem: selectedHour),
              itemExtent: 80,
              onSelectedItemChanged: _onHourChanged,
              children: List<Widget>.generate(24, (index) {
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: index == selectedHour
                        ? const TextStyle(
                            fontSize: 82,
                            color: Colors.white,
                            fontWeight: FontWeight.w200)
                        : const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(
            width: 10,
            child: Text(
              ":",
              style: TextStyle(
                  fontSize: 82,
                  color: Colors.white,
                  fontWeight: FontWeight.w200),
            ),
          ),
          // Minute Picker
          SizedBox(
            width: 100,
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: selectedMinute),
              selectionOverlay: Container(),
              looping: true,
              itemExtent: 80,
              onSelectedItemChanged: _onMinuteChanged,
              children: List<Widget>.generate(60, (index) {
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: index == selectedMinute
                        ? const TextStyle(
                            fontSize: 82,
                            color: Colors.white,
                            fontWeight: FontWeight.w200)
                        : const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../utils/days_array.dart';

class RepeatDayPicker extends StatelessWidget {
  final List<int> selectedDays;
  final void Function(bool, int) onDaysChanged;

  const RepeatDayPicker({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: DaysArray.days.asMap().entries.map((entry) {
        final int dayIndex = entry.key + 1; // Convert to 1-based index
        final String dayName = entry.value;
        final bool isSelected = selectedDays.contains(dayIndex);

        return GestureDetector(
          onTap: () {
            onDaysChanged(!isSelected, dayIndex);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              dayName,
              style: TextStyle(
                fontSize: 13.5,
                color: isSelected
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        );
      }).followedBy([
        GestureDetector(
          onTap: () {
            if (selectedDays.length < DaysArray.days.length) {
              for (int i = 1; i <= DaysArray.days.length; i++) {
                onDaysChanged(true, i);
              }
            } else {
              for (int i = 1; i <= DaysArray.days.length; i++) {
                onDaysChanged(false, i);
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: DaysArray.days.length == selectedDays.length
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: DaysArray.days.length == selectedDays.length
                  ? [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              'All',
              style: TextStyle(
                fontSize: 13.5,
                color: DaysArray.days.length == selectedDays.length
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
      ]).toList(),
    );
  }
}

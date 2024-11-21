import 'package:flutter/material.dart';

class Format {
  static String formatPlanLabel(String label) {
    return label
        .split('_') // Split the label by underscores
        .map((word) =>
            word[0].toUpperCase() + word.substring(1)) // Capitalize each word
        .join(' '); // Join words with a space
  }

  static IconData getTriggerIcon(String trigger) {
    switch (trigger.toLowerCase()) {
      case 'smell':
        return Icons.spa; // Example icon for smell
      case 'active_light':
        return Icons.lightbulb;
      case 'speaker':
        return Icons.speaker;
      default:
        return Icons.device_unknown; // Fallback icon
    }
  }

  static String formatDuration(int duration) {
    if (duration > 60) {
      return '${(duration / 60).toInt()}m';
    } else {
      return '${duration}s';
    }
  }

  static String formatAlarmTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static DateTime convertTimeOfDayToDateTime(TimeOfDay timeOfDay,
      {DateTime? date}) {
    final now = date ?? DateTime.now();
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }
}

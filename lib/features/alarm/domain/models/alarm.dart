class Alarm {
  final int id;
  final String label;
  final DateTime time;
  final bool isActive;
  final List<int> days;
  final String planId;
  final String ringtone;

  Alarm({
    required this.id,
    required this.label,
    required this.time,
    this.isActive = true,
    required this.days,
    required this.planId,
    required this.ringtone,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      label: json['label'],
      time: DateTime.parse(json['time']),
      isActive: json['isActive'],
      days: List<int>.from(json['days']),
      planId: json['planId'],
      ringtone: json['ringtone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'time': time.toIso8601String(),
      'isActive': isActive,
      'days': days,
      'planId': planId,
      'ringtone': ringtone,
    };
  }

  Alarm copyWith({
    int? id,
    String? label,
    DateTime? time,
    bool? isActive,
    List<int>? days,
    String? planId,
    String? ringtone,
  }) {
    return Alarm(
      id: id ?? this.id,
      label: label ?? this.label,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      days: days ?? this.days,
      planId: planId ?? this.planId,
      ringtone: ringtone ?? this.ringtone,
    );
  }

  Alarm toggleActive() {
    return Alarm(
      id: id,
      label: label,
      time: time,
      isActive: !isActive,
      days: days,
      planId: planId,
      ringtone: ringtone,
    );
  }
}

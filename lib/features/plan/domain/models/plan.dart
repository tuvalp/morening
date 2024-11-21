import 'stage.dart';

class Plan {
  final String label;
  final int startDeltaBeforeAwake;
  final List<Stage> stages;

  Plan({
    required this.label,
    required this.startDeltaBeforeAwake,
    required this.stages,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'startDeltaBeforeAwake': startDeltaBeforeAwake,
        'stages': stages.map((stage) => stage.toJson()).toList(),
      };

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        label: json['label'],
        startDeltaBeforeAwake: json['startDeltaBeforeAwake'],
        stages: (json['stages'] as List<dynamic>)
            .map((stage) => Stage.fromJson(stage))
            .toList(),
      );
}

class Stage {
  final int deltaTime;
  final String trigger;
  final double volume;
  final int duration;
  final String? songPath;

  Stage({
    required this.deltaTime,
    required this.trigger,
    required this.volume,
    required this.duration,
    this.songPath,
  });

  Map<String, dynamic> toJson() => {
        'deltaTime': deltaTime,
        'trigger': trigger,
        'volume': volume,
        'duration': duration,
        'song_path': songPath,
      };

  factory Stage.fromJson(Map<String, dynamic> json) => Stage(
        deltaTime: json['deltaTime'],
        trigger: json['trigger'],
        volume: json['volume'].toDouble(),
        duration: json['duration'],
        songPath: json['song_path'],
      );
}

class Settings {
  final bool darkMode;

  Settings({
    this.darkMode = false,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      darkMode: json['darkMode'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
    };
  }

  Settings copyWith({
    bool? darkMode,
  }) {
    return Settings(
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

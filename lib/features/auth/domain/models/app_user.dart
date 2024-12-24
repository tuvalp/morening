class AppUser {
  final String id;
  final String email;
  final String name;
  final String? deviceId;
  final String? wakeUpProfile;
  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.deviceId,
    this.wakeUpProfile = "{}",
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['user_id'] ?? "",
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      deviceId: json['deviceId'] ?? "",
      wakeUpProfile: json['wake_up_profile'][''] ?? "{}",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'deviceId': deviceId,
      'wake_up_profile': wakeUpProfile ?? "{}",
    };
  }
}

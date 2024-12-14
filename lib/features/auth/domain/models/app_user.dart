class AppUser {
  final String id;
  final String email;
  final String name;
  final String? deviceId;

  AppUser(
      {required this.id,
      required this.email,
      required this.name,
      this.deviceId});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['user_id'] ?? "",
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      deviceId: json['deviceId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'deviceId': deviceId,
    };
  }
}

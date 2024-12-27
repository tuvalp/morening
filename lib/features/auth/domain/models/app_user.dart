import 'answer.dart';

class AppUser {
  final String id;
  final String email;
  final String name;
  final String? deviceId;
  final List<Answer>? wakeUpProfile;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.deviceId,
    this.wakeUpProfile,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['user_id'] ?? "", // Ensure a fallback if null
      email: json['email'] ?? "", // Ensure a fallback if null
      name: json['name'] ?? "", // Ensure a fallback if null
      deviceId: json['paired_device_id'], // Nullable
      wakeUpProfile: (json['wake_up_profile'] as List<dynamic>?)
          ?.map(
            (e) => Answer.fromJson(e as Map<String, dynamic>),
          )
          .toList(), // Deserialize `wake_up_profile` list
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'email': email,
      'name': name,
      'paired_device_id': deviceId,
      'wake_up_profile': wakeUpProfile?.map((e) => e.toJson()).toList(),
    };
  }
}

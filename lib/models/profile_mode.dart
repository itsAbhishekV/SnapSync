class ProfileModel {
  final String id;
  final String username;
  final DateTime? createdAt;

  const ProfileModel({
    required this.id,
    required this.username,
    this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

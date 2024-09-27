import 'package:snapsync/models/exports.dart';

class SnapModel {
  final int id;
  final String title;
  final String imageId;
  final DateTime createdAt;
  final ProfileModel profile;

  const SnapModel({
    required this.id,
    required this.title,
    required this.imageId,
    required this.createdAt,
    required this.profile,
  });

  factory SnapModel.fromJson(Map<String, dynamic> json) {
    return SnapModel(
      id: json['id'] as int,
      title: json['title'] as String,
      imageId: json['image_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      profile: ProfileModel.fromJson(json['profiles'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_id': imageId,
      'created_at': createdAt.toIso8601String(),
      'profiles': profile.toJson(),
    };
  }
}

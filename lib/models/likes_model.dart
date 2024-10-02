class LikesModel {
  final int count;
  final bool isLiked;

  const LikesModel({
    required this.count,
    required this.isLiked,
  });

  factory LikesModel.fromJson(Map<String, dynamic> json) {
    return LikesModel(
      count: json['count'] as int,
      isLiked: json['isLiked'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'isLiked': isLiked,
    };
  }
}

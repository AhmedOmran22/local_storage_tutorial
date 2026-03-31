class PostModel {
  final String id;
  final String username;
  final String userImage;
  final String imageUrl;
  final String caption;
  final int likes;

  const PostModel({
    required this.id,
    required this.username,
    required this.userImage,
    required this.imageUrl,
    required this.caption,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "userImage": userImage,
    "imageUrl": imageUrl,
    "caption": caption,
    "likes": likes,
  };

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json["id"],
      username: json["username"],
      userImage: json["userImage"],
      imageUrl: json["imageUrl"],
      caption: json["caption"],
      likes: json["likes"],
    );
  }
}

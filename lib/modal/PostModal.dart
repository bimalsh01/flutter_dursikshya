class PostModal {
  String title;
  String userId;
  String? username;
  DateTime? createdAt;
  String? url;
  List<String>? likes;

  PostModal({
    required this.title,
    required this.userId,
    this.username,
    this.createdAt,
    this.url,
    this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'userId': userId,
      'username': username,
      'createdAt': createdAt,
      'url': url,
      'likes': likes,
    };
  }
}

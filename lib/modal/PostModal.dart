class PostModal {
  String title;
  String userId;
  String? name;
  DateTime? createdAt;
  String? url;

  PostModal({
    required this.title,
    required this.userId,
    this.name,
    this.createdAt,
    this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'userId': userId,
      'name': name,
      'createdAt': createdAt,
      'url': url,
    };
  }
}

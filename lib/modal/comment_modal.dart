class Comment {
  String username;
  String comment;

  Comment({
    required this.username,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'comment': comment,
    };
  }
}

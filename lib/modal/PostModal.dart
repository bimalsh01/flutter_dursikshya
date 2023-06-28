import 'package:traveldiary/modal/comment_modal.dart';

class PostModal {
  String title;
  String userId;
  String? username;
  DateTime? createdAt;
  String? url;
  List<String>? likes;
  List<Comments>? comments;

  PostModal({
    required this.title,
    required this.userId,
    this.username,
    this.createdAt,
    this.url,
    this.likes,
    this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'userId': userId,
      'username': username,
      'createdAt': createdAt,
      'url': url,
      'likes': likes,
      'comments': comments?.map((comment) => comment.toJson()).toList()
    };
  }
}

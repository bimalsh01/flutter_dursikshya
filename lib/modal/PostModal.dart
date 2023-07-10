import 'package:traveldiary/modal/comment_modal.dart';

class PostModal {
  String? title;
  String? userId;
  String? username;
  DateTime? createdAt;
  String? url;
  List<String>? likes;
  List<Comments>? comments;

  PostModal({
     this.title,
     this.userId,
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


  

  // form map
  PostModal.fromMap(Map<String, dynamic> json)
      : title = json['title'],
        userId = json['userId'],
        username = json['username'],
        createdAt = json['createdAt'].toDate(),
        url = json['url'],
        likes = json['likes'].cast<String>();
}

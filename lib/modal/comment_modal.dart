class Comments {
  String? username;
  String? comment;
  String? profileUrl;

  Comments({this.username, this.comment, this.profileUrl});

  // to json
  Map<String, dynamic> toJson() => {
        'username': username,
        'comment': comment,
        'profileUrl': profileUrl,
      };
}

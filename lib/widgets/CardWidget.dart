import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveldiary/screens/CommentScreen.dart';

class CardWidget extends StatefulWidget {
  final String username;
  final String title;
  final String url;
  final String postedDate;
  final String id;
  final List<dynamic>? likes;
  final List<dynamic>? comments;

  const CardWidget(
      {required this.username,
      required this.title,
      required this.url,
      required this.postedDate,
      required this.id,
      this.likes,
      this.comments,
      super.key});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  int likeCount = 0;
  bool isLiked = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    likeCount = widget.likes!.length;
    super.initState();
  }

  void handleLike() async {
    if (isLiked) {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .update({
        'likes': FieldValue.arrayRemove([userId])
      });
      setState(() {
        isLiked = false;
        likeCount--;
      });
    } else {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .update({
        'likes': FieldValue.arrayUnion([userId])
      });

      setState(() {
        isLiked = true;
        likeCount++;
      });
    }
  }

  // navigate to comment screen with arguments
  void navigateToCommentScreen() {
    // Navigator.pushNamed(context, '/comments', arguments: {
    //   'postId': widget.id,
    //   'comments': widget.comments,
    // });
    // build material

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommentScreen(
                  postId: widget.id,
                  comments: widget.comments,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('@${widget.username}'),
            subtitle: Text(widget.postedDate),
          ),
          Text(widget.title, style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Image.network(widget.url,
              height: 250, width: double.infinity, fit: BoxFit.cover),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        handleLike();
                      },
                      icon: isLiked
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border)),
                  Text('$likeCount')
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      navigateToCommentScreen();
                    },
                    icon: Icon(Icons.comment),
                  ),
                  Text('${widget.comments!.length ?? 0}')
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveldiary/modal/comment_modal.dart';
import 'package:traveldiary/state%20management/appdata.dart';

class PostCommentsScreen extends StatefulWidget {
  final String postId;
  final List<dynamic>? comments;

  const PostCommentsScreen({
    required this.postId,
    this.comments,
    Key? key,
  }) : super(key: key);

  @override
  _PostCommentsScreenState createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<PostCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<dynamic> _commentsList = [];

  @override
  void initState() {
    if (widget.comments != null) {
      _commentsList = List.from(widget.comments!);
    }
    super.initState();
  }

  Future<void> _addComment() async {
    final String comment = _commentController.text.trim();

    if (comment.isNotEmpty) {
      final username = Provider.of<AppData>(context, listen: false).username;
      final commentsData =
          Comment(username: username!, comment: comment).toJson();

      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .update({
          'comments': FieldValue.arrayUnion([commentsData])
        });

        setState(() {
          _commentsList.add(commentsData);
        });

        _commentController.clear();
      } catch (e) {
        print('Error adding comment: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _commentsList.length,
              itemBuilder: (context, index) {
                final comment = _commentsList[index];

                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
                    ),
                  ),
                  title: Text('@${comment['username']}'),
                  subtitle: Text(comment['comment']),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _addComment,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

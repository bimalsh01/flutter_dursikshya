
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveldiary/modal/comment_modal.dart';
import 'package:traveldiary/state%20management/appdata.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  List<dynamic>? comments;

  CommentScreen({required this.postId, this.comments, super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  // controller
  final TextEditingController _commentController = TextEditingController();
  List<dynamic>? commentLists;

  @override
  void initState() {
    commentLists = widget.comments;
    print(commentLists);
    super.initState();
  }

  Future<void> addComment() async {
    final String comments = _commentController.text.trim();

    if (comments.isNotEmpty) {
      final username = Provider.of<AppData>(context, listen: false).username;
      final profile = Provider.of<AppData>(context, listen: false).profile;

      final commentData = Comments(
        username: username,
        profileUrl: profile,
        comment: comments,
      ).toJson();

      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .update({
          'comments': FieldValue.arrayUnion([commentData])
        });

        setState(() {
          commentLists!.add(commentData);
          _commentController.clear();
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: commentLists!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/300'),
                      ),
                      title: Text("@${commentLists![index]['username']}"),
                      subtitle: Text("${commentLists![index]['comment']}"),
                    );
                  })),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment',
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    addComment();
                  },
                  icon: const Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }
}

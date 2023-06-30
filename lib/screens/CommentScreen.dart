import 'package:flutter/material.dart';

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
    super.initState();
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
                    return const ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/300'),
                      ),
                      title: Text('Username'),
                      subtitle: Text('Comment'),
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
              IconButton(onPressed: () {}, icon: const Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }
}

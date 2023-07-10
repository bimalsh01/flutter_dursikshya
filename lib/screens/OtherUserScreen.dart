import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:traveldiary/modal/PostModal.dart';

class OtherUserScreen extends StatefulWidget {
  const OtherUserScreen({super.key});

  @override
  State<OtherUserScreen> createState() => _OtherUserScreenState();
}

class _OtherUserScreenState extends State<OtherUserScreen> {
  String? userId;
  String? username;
  String? firstname;
  String? lastname;
  String? email;
  String? profile;
  List<PostModal> posts = [];

  @override
  void initState() {
    fetchPost();
    super.initState();
  }

  void fetchPost() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .get();

    querySnapshot.docs.forEach((doc) {
      posts.add(PostModal.fromMap(doc.data() as Map<String, dynamic>));
    });
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    userId = args['userId'];
    username = args['username'];
    firstname = args['firstname'];
    lastname = args['lastname'];
    email = args['email'];
    profile = args['profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text('$firstname $lastname'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(profile! ?? 'https://picsum.photos/250'),
                  radius: 30,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$firstname $lastname', style: TextStyle(fontSize: 25)),
                  Text('@$username', style: TextStyle(fontSize: 15)),
                ],
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Posts', style: TextStyle(fontSize: 20)),
                  Text('0', style: TextStyle(fontSize: 25)),
                ],
              ),
              Column(
                children: [
                  Text('Followers', style: TextStyle(fontSize: 20)),
                  Text('120', style: TextStyle(fontSize: 25)),
                ],
              ),
              OutlinedButton(onPressed: () {}, child: Text('Follow'))
            ],
          ),
          Divider(),
          Text('Showing posts', style: TextStyle(fontSize: 20)),
          Expanded(
              child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(10, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                          'https://picsum.photos/250?image=$index'),
                    );
                  })))
        ],
      ),
    );
  }
}

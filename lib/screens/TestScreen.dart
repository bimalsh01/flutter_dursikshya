import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveldiary/apis/rest_api.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // list of api user
  List users = [];

  @override
  void initState() {
    RestAPI.getUser().then((data) {
      setState(() {
        users = data['data'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: ListView(
        children: [
           for (var user in users)
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['avatar']),
              ),
              title: Text(user['first_name']),
              subtitle: Text(user['email']),
            )
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // way 1
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // way 2 shared preferences
  // SharedPreferences? prefs;
  // String id = prefs!.getString('id')!;

  Future _logout() async {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder: (context, snapshot) {
            print(snapshot.data!['firstname']);
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(snapshot.data!['firstname']),
                  ElevatedButton(onPressed: _logout, child: Text("Logout"))
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

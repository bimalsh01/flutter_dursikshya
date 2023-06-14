import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveldiary/state%20management/appdata.dart';

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
    String? firstname = Provider.of<AppData>(context, listen: false).firstname;
    String? lastname = Provider.of<AppData>(context, listen: false).lastname;
    String? email = Provider.of<AppData>(context, listen: false).email;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: Image.asset('assets/icons/profile.png').image,
            ),
            const SizedBox(height: 20),
            Text("$firstname $lastname", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("$email", style: TextStyle(fontSize: 20)),
            Divider(),
            Expanded(
                child: ListView(children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                subtitle: const Text('Click here to edit profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: const Icon(Icons.content_copy),
                title: const Text('My Posts'),
                subtitle: const Text('Click here to view my posts'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/myposts');
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Change password'),
                subtitle: const Text('Set your new password'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                subtitle: const Text('Logout from the app'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _logout();
                },
              ),
            ]))
          ],
        ));
  }
}

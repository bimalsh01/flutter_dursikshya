import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveldiary/state%20management/appdata.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? name;

  @override
  Widget build(BuildContext context) {
    // name = Provider.of<AppData>(context).name;

    return Scaffold(
        appBar: AppBar(
          title: Text('Travel Diary'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance.collection('posts').doc().get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('Bimal Shrestha'),
                        subtitle: Text('posted: 2 hours ago'),
                      ),
                      Text('This is my first post. I am so excited to be here.',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Image.asset('assets/images/abc.jpg',
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}

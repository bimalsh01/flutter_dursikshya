import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveldiary/state%20management/appdata.dart';
import 'package:timeago/timeago.dart' as timeago;

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
            future: FirebaseFirestore.instance.collection('posts').get(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];

                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.account_circle),
                              title: Text('@${ds['username']}'),
                              subtitle: Text(
                                  timeago.format(ds['createdAt'].toDate())),
                            ),
                            Text('${ds['title']}',
                                style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            Image.network('${ds['url']}',
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.favorite_border),
                                    ),
                                    Text('16')
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.comment),
                                    ),
                                    Text('16')
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })));
  }
}

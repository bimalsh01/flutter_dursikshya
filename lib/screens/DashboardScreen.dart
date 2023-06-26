import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveldiary/state%20management/appdata.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:traveldiary/widgets/CardWidget.dart';

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

                      // get data from ds (DocmentSnapshot)
                      String username = ds['username'];
                      String title = ds['title'];
                      String url = ds['url'];
                      String postedDate =
                          timeago.format(ds['createdAt'].toDate());
                      String id = ds.id;
                      List<dynamic>? likes = ds['likes'];

                      return CardWidget(
                          username: username,
                          title: title,
                          url: url,
                          postedDate: postedDate,
                          id: id,
                          likes: likes);
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })));
  }
}

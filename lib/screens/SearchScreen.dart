import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text('Search'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                placeholder: 'Search posts',
                autofocus: true,
                prefix: const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.search),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                suffix: GestureDetector(
                  onTap: () {
                    _searchController.clear();
                  },
                  child: const Icon(Icons.clear),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('username',
                          isGreaterThanOrEqualTo: _searchController.text)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }

                    final List<DocumentSnapshot> users = snapshot.data!.docs;

                    return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          if (_searchController.text.isEmpty) {
                            return Container();
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/otheruser',
                                  arguments: users[index].data());
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(users[index]
                                        ['profile'] ??
                                    'https://picsum.photos/200'),
                              ),
                              title: Text(users[index]['username']),
                              subtitle: Text(users[index]['email']),
                            ),
                          );
                        });
                  }),
            )
          ],
        ));
  }
}

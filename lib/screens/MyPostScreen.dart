import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:permission_handler/permission_handler.dart';
import 'package:traveldiary/state%20management/appdata.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../modal/PostModal.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  // show confirmation dialog for delete post
  Future<void> _showConfirmationDalog(String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Post'),
            content: Text('Are you sure you want to delete this post?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(id)
                        .delete();
                    Navigator.pop(context);
                  },
                  child: Text('Delete')),
            ],
          );
        });
  }

  // load image from camera or gallery
  File? img;
  String? username;

  Future _loadImage(ImageSource imageSource) async {
    //  request permission by using permission_handler package
    final permission = await Permission.camera.request();
    if (permission.isDenied) {
      await Permission.camera.request();
    }

    try {
      final image = await ImagePicker().pickImage(source: imageSource);

      if (image != null) {
        setState(() {
          img = File(image.path);
        });
      } else {
        print('No image selected.');
      }
      ;
    } catch (e) {
      print(e);
    }
  }

  // edit post dialog
  TextEditingController _editTitleController = TextEditingController();
  Future<void> _editPostDialog(String id, String title, String url) async {
    _editTitleController.text = title;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Post'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextFormField(
                    controller: _editTitleController,
                    decoration: InputDecoration(
                      hintText: 'Enter title',
                    ),
                  ),
                  // Image.network(url, width: 100, height: 100),

                  // show image from camera or gallery #IISUE_1
                  img == null
                      ? Image.network(url, width: 100, height: 100)
                      : Image.file(img!, width: 100, height: 100),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            _loadImage(ImageSource.camera);
                          },
                          child: Text('Camera')),
                      ElevatedButton(
                          onPressed: () {
                            _loadImage(ImageSource.gallery);
                          },
                          child: Text('Gallary')),
                    ],
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    if (img != null) {
                      try {
                        final path = 'posts/${DateTime.now()}.png';
                        final ref = await firebase_storage
                            .FirebaseStorage.instance
                            .ref()
                            .child(path);

                        await ref.putFile(img!);
                        final newUrl = await ref.getDownloadURL();

                        final post = PostModal(
                          title: _editTitleController.text,
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          username: username,
                          createdAt: DateTime.now(),
                          url: newUrl,
                        );

                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(id)
                            .update(post.toJson());

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Post Updated with image!')));

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Failed to update post with image')));
                      }
                    } else {
                      //  if no image is selected
                      try {
                        final post = PostModal(
                          title: _editTitleController.text,
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          username: username,
                          createdAt: DateTime.now(),
                          url: url,
                        );

                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(id)
                            .update(post.toJson());

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Post Updated')));

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Failed to update post without image')));
                      }
                    }
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    username = Provider.of<AppData>(context).username;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('posts')
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return ListTile(
                      leading: Image.network('${ds['url']}'),
                      title: Text('${ds['title']}'),
                      subtitle: Text(timeago.format(ds['createdAt'].toDate())),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _editPostDialog(ds.id, ds['title'], ds['url']);
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _showConfirmationDalog(ds.id);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          })),
    );
  }
}

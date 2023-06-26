import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// impot firebase_storage package

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:traveldiary/modal/PostModal.dart';
import 'package:traveldiary/state%20management/appdata.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? img;
  String? username;
  TextEditingController titleController = TextEditingController();

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

  Future _addPost() async {
    String? url;

    try {
      final path = 'posts/${DateTime.now()}.png';
      final file = File(img!.path);
      final ref = await firebase_storage.FirebaseStorage.instance.ref(path);
      await ref.putFile(file);

      url = await ref.getDownloadURL();
    } catch (e) {
      print('Failed to uload image $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to uload image'),
        ),
      );
    }

    try {
      final post = PostModal(
        title: titleController.text,
        userId: FirebaseAuth.instance.currentUser!.uid,
        username: username,
        createdAt: DateTime.now(),
        url: url,
        likes: [],
      );

      // add post to firestore
      await FirebaseFirestore.instance.collection('posts').add(post.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post added'),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add post'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    username = Provider.of<AppData>(context).username;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add post'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(onPressed: _addPost, icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Create a title',
                border: OutlineInputBorder(),
              ),
            ),
            img == null ? Text("No image selected") : Image.file(img!),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.camera_rotate), label: 'Camera'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.collections), label: 'Gallary'),
        ],
        onTap: (int index) {
          if (index == 0) {
            _loadImage(ImageSource.camera);
          } else {
            _loadImage(ImageSource.gallery);
          }
        },
      ),
    );
  }
}

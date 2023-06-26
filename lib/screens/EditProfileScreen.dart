import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:traveldiary/modal/user_modal.dart';
import 'package:traveldiary/state%20management/appdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // setp 1 controllers
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // load image
  File? img;
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

  // declare form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // decare variables
  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? profile;

  void updateProfileWithImage() {}

  void updateProfileWithoutImage() {}

  // step 4 save data to firebase
  void updateProfile() async {
    if (img != null) {
      try {
        final path = 'users/${DateTime.now()}.png';
        final file = File(img!.path);
        final ref = await firebase_storage.FirebaseStorage.instance.ref(path);
        await ref.putFile(file);

        // get image url
        String newUrl = await ref.getDownloadURL();

        // modal
        final user = UserModal(
          firstname: _firstnameController.text,
          lastname: _lastnameController.text,
          email: _emailController.text,
          username: _usernameController.text,
          profile: newUrl,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(user.toJson());

        // step 5 update data to provider
        Provider.of<AppData>(context, listen: false).updateUser(
            _firstnameController.text,
            _lastnameController.text,
            _emailController.text,
            _usernameController.text,
            newUrl);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile Updated with image!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update profile')));
      }
    } else {
      final user = UserModal(
        firstname: _firstnameController.text,
        lastname: _lastnameController.text,
        email: _emailController.text,
        username: _usernameController.text,
      );
      print(user.toJson());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(user.toJson());

      // step 5 update data to provider
      Provider.of<AppData>(context, listen: false).updateUser(
          _firstnameController.text,
          _lastnameController.text,
          _emailController.text,
          _usernameController.text,
          '');

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile Updated!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // step 3 load data from provider
    firstname = Provider.of<AppData>(context).firstname;
    lastname = Provider.of<AppData>(context).lastname;
    email = Provider.of<AppData>(context).email;
    username = Provider.of<AppData>(context).username;
    profile = Provider.of<AppData>(context).profile;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                  radius: 50,
                  backgroundImage: img != null
                      ? FileImage(img!)
                      : Image.network(profile!).image),
              TextButton(
                  onPressed: () {
                    _loadImage(ImageSource.gallery);
                  },
                  child: Text('Change Profile Picture')),

              // firstname and lastname in a row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstnameController..text = firstname!,

                      // step 2 validator
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 2) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _lastnameController..text = lastname!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController..text = username!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController..text = email!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    // third step
                    if (_formKey.currentState!.validate()) {
                      updateProfile();
                    }
                  },
                  child: Text('Update Profile'))
            ],
          ),
        ),
      ),
    );
  }
}

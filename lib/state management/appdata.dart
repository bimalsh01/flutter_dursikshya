import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData extends ChangeNotifier {
  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? profile;

  void updateUser(
      String firstname, String lastname, String email, String username, String profile) {
    this.firstname = firstname;
    this.lastname = lastname;
    this.email = email;
    this.username = username;
    this.profile = profile;
    saveData();
    notifyListeners();
  }

  // save data in shared preferences
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstname', firstname!);
    prefs.setString('lastname', lastname!);
    prefs.setString('email', email!);
    prefs.setString('username', username!);
    prefs.setString('profile', profile!);
  }

  // Load data from shared preferences
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstname = prefs.getString('firstname') ?? '';
    lastname = prefs.getString('lastname') ?? '';
    email = prefs.getString('email') ?? '';
    username = prefs.getString('username') ?? '';
    profile = prefs.getString('profile') ?? '';
    notifyListeners();
  }
}

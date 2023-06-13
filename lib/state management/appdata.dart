import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  String? firstname;
  String? lastname;
  String? email;
  String? username;

  void updateUser(
      String firstname, String lastname, String email, String username) {
    this.firstname = firstname;
    this.lastname = lastname;
    this.email = email;
    this.username = username;

    notifyListeners();
  }
}

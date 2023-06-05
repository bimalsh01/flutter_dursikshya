import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  String name = "Bimal Stha updated";

  void updateName(String name) {
    name = name;
    notifyListeners();
  }
}

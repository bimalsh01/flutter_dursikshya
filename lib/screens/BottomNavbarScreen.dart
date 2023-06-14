import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveldiary/screens/AddPostScreen.dart';
import 'package:traveldiary/screens/DashboardScreen.dart';
import 'package:traveldiary/screens/ProfileScreen.dart';
import 'package:traveldiary/state%20management/appdata.dart';

class BottomNavbarScreen extends StatefulWidget {
  const BottomNavbarScreen({super.key});

  @override
  State<BottomNavbarScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends State<BottomNavbarScreen> {
  int _selectedIndex = 0;

  // list of screens
  List<Widget> lstWidget = [
    const DashboardScreen(),
    const AddPostScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    Provider.of<AppData>(context, listen: false).loadData();
    return Scaffold(
      body: Center(child: lstWidget.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'Add post',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex, // 0 add student, 1 view student
        unselectedItemColor: Colors.black,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}

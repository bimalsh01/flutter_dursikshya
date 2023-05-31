import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:traveldiary/screens/AddPostScreen.dart';
import 'package:traveldiary/screens/BottomNavbarScreen.dart';
import 'package:traveldiary/screens/DashboardScreen.dart';
import 'package:traveldiary/screens/LoginScreen.dart';
import 'package:traveldiary/screens/ProfileScreen.dart';
import 'package:traveldiary/screens/RegisterScreen.dart';
import 'package:traveldiary/screens/SplashScreen.dart';
import 'package:traveldiary/screens/TestScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
    routes: {
      '/': (context) => const TestScreen(),
      '/splash': (context) => const SplashScreen(),
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/dashboard': (context) => const DashboardScreen(),
      '/buttonNavbarScreen': (context) => const BottomNavbarScreen(),
      '/addpost': (context) => const AddPostScreen(),
      '/profile': (context) => const ProfileScreen(),
    },
  ));
}

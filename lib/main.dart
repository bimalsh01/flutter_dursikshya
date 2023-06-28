import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveldiary/screens/AddPostScreen.dart';
import 'package:traveldiary/screens/BottomNavbarScreen.dart';
import 'package:traveldiary/screens/CommentScreen.dart';
import 'package:traveldiary/screens/DashboardScreen.dart';
import 'package:traveldiary/screens/EditProfileScreen.dart';
import 'package:traveldiary/screens/LoginScreen.dart';
import 'package:traveldiary/screens/MyPostScreen.dart';
import 'package:traveldiary/screens/ProfileScreen.dart';
import 'package:traveldiary/screens/RegisterScreen.dart';
import 'package:traveldiary/screens/SplashScreen.dart';
import 'package:traveldiary/screens/TestScreen.dart';
import 'package:traveldiary/state%20management/appdata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppData()),
      ],
      child: MaterialApp(
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
          '/myposts': (context) => const MyPostScreen(),
          '/editprofile': (context) => const EditProfileScreen(),
          '/comments': (context) => const CommentScreen(),
        },
      )));
}

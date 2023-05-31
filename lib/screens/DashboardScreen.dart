import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Travel Diary'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Bimal Shrestha'),
                      subtitle: Text('posted: 2 hours ago'),
                    ),
                    Text('This is my first post. I am so excited to be here.',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Image.asset('assets/images/abc.jpg',
                        height: 250, width: double.infinity, fit: BoxFit.cover),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Bimal Shrestha'),
                      subtitle: Text('posted: 2 hours ago'),
                    ),
                    Text('This is my first post. I am so excited to be here.',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Image.asset('assets/images/abc.jpg',
                        height: 250, width: double.infinity, fit: BoxFit.cover),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

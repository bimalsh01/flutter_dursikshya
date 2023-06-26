import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final String username;
  final String title;
  final String url;
  final String postedDate;
  final String id;
  final List<dynamic>? likes;

  const CardWidget(
      {required this.username,
      required this.title,
      required this.url,
      required this.postedDate,
      required this.id,
      this.likes,
      super.key});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('@username'),
            subtitle: Text('2 days ago'),
          ),
          Text(widget.title, style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Image.network('',
              height: 250, width: double.infinity, fit: BoxFit.cover),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border),
                  ),
                  Text('16')
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.comment),
                  ),
                  Text('16')
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

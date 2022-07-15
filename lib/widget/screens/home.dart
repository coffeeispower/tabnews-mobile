import 'package:flutter/material.dart';
import 'package:tabnews/api/login.dart';
import 'package:tabnews/widget_factories/appbar.dart';
import 'package:tabnews/widget/post_list.dart';

import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!await isLoggedIn()) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          }
        },
        tooltip: 'Publish',
        elevation: 10,
        child: const Icon(Icons.add),
      ),
      body: const PostList(),
    );
  }
}

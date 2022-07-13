import 'package:flutter/material.dart';
import 'package:tabnews/appbar.dart';
import 'package:tabnews/post_list.dart';

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
      appBar: app_bar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Publish',
        elevation: 0,
        child: const Icon(Icons.add),
      ),
      body: const PostList(),
    );
  }
}

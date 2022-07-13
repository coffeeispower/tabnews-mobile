import 'package:flutter/material.dart';
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
      appBar: AppBar(
          title: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Image.asset("assets/favicon-dark.png", width: 30)),
              const Text("TabNews")
            ],
          ),
          elevation: 0),
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

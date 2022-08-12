import 'package:flutter/material.dart';
import 'package:tabnews/api/login.dart';
import 'package:tabnews/components/appbar/appbar_home.dart';
import 'package:tabnews/components/feed/post_list.dart';

import '../login/login.dart';

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
      appBar: appbar_home(context),
      body: const PostList(),

      //botão para criar uma nova publicação
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //verificar se o usuario esta logado para pode publicar
          if (!await isLoggedIn()) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          } else {}
        },
        backgroundColor: Colors.green,
        tooltip: 'Publish',
        elevation: 10,
        child: const Icon(Icons.create),
      ),
    );
  }
}

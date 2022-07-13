import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tabnews/appbar.dart';
import 'package:tabnews/post.dart';

import 'get_contents.dart';

class PostScreen extends StatelessWidget {
  final String username;
  final String slug;
  const PostScreen({super.key, required this.username, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: app_bar(),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var post = snapshot.data! as Post;
            return SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: 40.0, top: 40.0, right: 10, left: 10),
                      child: Text(
                        post.title,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: MarkdownBody(
                            data: post.body!,
                            selectable: true,
                            styleSheet: MarkdownStyleSheet(
                              h1: TextStyle(fontWeight: FontWeight.bold),
                              h2: TextStyle(fontWeight: FontWeight.bold),
                              h3: TextStyle(fontWeight: FontWeight.bold),
                              h4: TextStyle(fontWeight: FontWeight.bold),
                              h5: TextStyle(fontWeight: FontWeight.bold),
                              h6: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )))
                ],
              ),
            ));
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text("Não foi possivel carregar o post!"));
          }

          return const Center(child: CircularProgressIndicator());
        },
        future: fetchPost(username, slug),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tabnews/markdown.dart';
import 'package:tabnews/widget_factories/appbar.dart';
import 'package:tabnews/data_structures/post.dart';
import 'package:markdown/markdown.dart' as md;
import '../../api/fetch_api.dart';
import '../comments.dart';

class PostScreen extends StatelessWidget {
  final String username;
  final String slug;
  final String title;
  const PostScreen(
      {super.key,
      required this.username,
      required this.slug,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: app_bar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 40.0,
                top: 40.0,
                right: 10,
                left: 10,
              ),
              child: Hero(
                tag: 'post$username$slug',
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var post = snapshot.data! as Post;
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Markdown(post.body!),
                          ),
                        ),
                        CommentsLoader(username: username, slug: slug)
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Não foi possivel carregar o post!"),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
              future: fetchPost(username, slug),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tabnews/appbar.dart';
import 'package:tabnews/post.dart';
import 'package:markdown/markdown.dart' as md;
import 'get_contents.dart';

class PostScreen extends StatelessWidget {
  final String username;
  final String slug;
  const PostScreen({super.key, required this.username, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: app_bar(context),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var post = snapshot.data! as Post;
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          bottom: 40.0, top: 40.0, right: 10, left: 10),
                      child: Text(
                        post.title,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                  Card(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: MarkdownBody(
                            // Cuidado com a gambiarra:
                            data: post.body!
                                .replaceAll(
                                    RegExp("\\<(\\/)?(bold|strong)\\>"), "**")
                                .replaceAll(RegExp("\\<h1\\>"), "# ")
                                .replaceAll(RegExp("\\<h2\\>"), "## ")
                                .replaceAll(RegExp("\\<h3\\>"), "### ")
                                .replaceAll(RegExp("\\<h4\\>"), "#### ")
                                .replaceAll(RegExp("\\<h5\\>"), "##### ")
                                .replaceAll(RegExp("\\<h6\\>"), "###### ")
                                .replaceAll(RegExp("\\<\\/*.\\>"), ""),
                            selectable: true,
                            inlineSyntaxes: [md.InlineHtmlSyntax()],
                            styleSheet: MarkdownStyleSheet(
                              h1: const TextStyle(fontWeight: FontWeight.bold),
                              h2: const TextStyle(fontWeight: FontWeight.bold),
                              h3: const TextStyle(fontWeight: FontWeight.bold),
                              h4: const TextStyle(fontWeight: FontWeight.bold),
                              h5: const TextStyle(fontWeight: FontWeight.bold),
                              h6: const TextStyle(fontWeight: FontWeight.bold),
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

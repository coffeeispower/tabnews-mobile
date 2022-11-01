import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_markdown/flutter_markdown.dart";
import 'package:tabnews_flutter/client/client.dart';
import "package:timeago/timeago.dart" as timeago;

import '../../client/entities/content.dart';

class ContentLoader extends StatelessWidget {
  final String author, slug;
  final Function(BuildContext, Content) builder;

  const ContentLoader(
      {super.key,
      required this.builder,
      required this.author,
      required this.slug});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TabNewsClient.getContent(author, slug, true),
        builder: (ctx, snap) {
          if (snap.hasData) {
            return builder(ctx, snap.data!);
          }
          if (snap.hasError) {
            if (kDebugMode) {
              print(snap.error);
            }
            return const Center(
                child: Text("Um erro ocorreu enquanto esse post carregava."));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class ContentPage extends StatelessWidget {
  final String author, slug, title;

  const ContentPage(this.title, this.author, this.slug, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ContentLoader(
        author: author,
        slug: slug,
        builder: (context, content) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      UsernameBadge(author: author),
                      Text(timeago.format(content.created_at, locale: "pt"),
                          style: Theme.of(context).textTheme.caption)
                    ],
                  ),
                  MarkdownBody(data: content.body!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class UsernameBadge extends StatelessWidget {
  const UsernameBadge({
    super.key,
    required this.author,
  });

  final String author;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[200],
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          author,
          style: TextStyle(
            color: Colors.blue[800],
            fontFamily: "monospace",
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}

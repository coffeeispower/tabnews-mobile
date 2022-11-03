import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_markdown/flutter_markdown.dart";
import 'package:provider/provider.dart';
import 'package:tabnews_flutter/client/client.dart';
import 'package:tabnews_flutter/main.dart';
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
          return SingleChildScrollView(child: ContentView(content: content));
        },
      ),
    );
  }
}

class ContentView extends StatefulWidget {
  ContentView({Key? key, required this.content, this.level = 1})
      : super(key: key);
  int level;
  final Content content;

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  late Content content;
  bool voting = false;
  @override
  void initState() {
    super.initState();
    content = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    var session = context.watch<SessionState>().session;
    var client = session != null ? TabNewsClient(session) : null;
    return Padding(
      padding: EdgeInsets.only(
          top: 20.0, bottom: 20.0, right: 10.0, left: 10.0 * widget.level),
      child: Column(
        children: [
          Row(
            children: [
              UsernameBadge(author: content.owner_username),
              Text(
                timeago.format(content.created_at, locale: "pt"),
                style: Theme.of(context).textTheme.caption,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_drop_up_sharp),
                onPressed: voting || client == null ? null : () {

                  setState((){
                    voting = true;
                  });
                  content.upvote(client).then((v) {
                    setState(() {
                      content.tabcoins += 1;
                      voting = false;
                    });
                  });
                },
              ),
              Text(content.tabcoins.toString(),
                  style: TextStyle(color: Colors.blue[300], fontSize: 15)),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down_sharp),
                onPressed: voting || client == null ? null : () {
                  setState((){
                    voting = true;
                  });
                  content.downvote(client).then((v) {
                    setState(() {
                      content.tabcoins -= 1;
                      voting = false;
                    });
                  });
                },
              ),
            ],
          ),
          MarkdownBody(data: content.body!),
          ...content.children!
              .map((e) => ContentView(content: e, level: widget.level + 1))
              .toList()
        ],
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

import 'dart:math';

import 'package:flutter/material.dart';
import "package:flutter_markdown/flutter_markdown.dart";
import 'package:provider/provider.dart';
import 'package:tabnews_flutter/client/client.dart';
import 'package:tabnews_flutter/main.dart';
import "package:timeago/timeago.dart" as timeago;
import 'package:confetti/confetti.dart' as confetti;
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
  const ContentView({Key? key, required this.content}) : super(key: key);
  final Content content;

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  late Content content;
  bool voting = false;
  final upvoteConfettiController =
      confetti.ConfettiController(duration: const Duration(milliseconds: 1));
  final downvoteConfettiController =
      confetti.ConfettiController(duration: const Duration(milliseconds: 1));
  @override
  void initState() {
    super.initState();
    content = widget.content;
  }

  @override
  void dispose() {
    super.dispose();
    upvoteConfettiController.dispose();
  }

  void upvoteButtonOnPress(TabNewsClient client) {
    setState(() {
      voting = true;
    });
    client.upvote(content).then((v) {
      setState(() {
        content.tabcoins += 1;
        voting = false;
        upvoteConfettiController.play();
      });
    }).catchError((e) {
      setState(() {
        voting = false;
        // Show error with snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${e['message']} ${e['action']}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      });
    });
  }

  void downvoteButtonOnPress(TabNewsClient client) {
    setState(() {
      voting = true;
    });
    content.downvote(client).then((v) {
      setState(() {
        content.tabcoins -= 1;
        voting = false;
        downvoteConfettiController.play();
      });
    }).catchError((e) {
      setState(() {
        voting = false;
        // Show error with snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${e['message']} ${e['action']}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var session = context.watch<SessionState>().session;
    var client = session != null ? TabNewsClient(session) : null;
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20.0,
        right: 10.0,
        left: 10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              UsernameBadge(author: content.owner_username),
              Text(
                timeago.format(content.created_at, locale: "pt"),
                style: Theme.of(context).textTheme.caption,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      confetti.ConfettiWidget(
                        confettiController: upvoteConfettiController,
                        gravity: 0.2,
                        shouldLoop: false,
                        maxBlastForce: 20,
                        minBlastForce: 10,
                        numberOfParticles: 20,
                        blastDirectionality:
                            confetti.BlastDirectionality.explosive,
                        blastDirection: -pi / 2,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up_sharp),
                        onPressed: voting || client == null
                            ? null
                            : () => upvoteButtonOnPress(client),
                      )
                    ],
                  ),
                  Text(content.tabcoins.toString(),
                      style: TextStyle(color: Colors.blue[300], fontSize: 15)),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        onPressed: voting || client == null
                            ? null
                            : () => downvoteButtonOnPress(client),
                      ),
                      confetti.ConfettiWidget(
                        colors: const [Color.fromARGB(255, 255, 60, 60)],
                        confettiController: downvoteConfettiController,
                        gravity: 0.3,
                        shouldLoop: false,
                        maxBlastForce: 1.1,
                        minBlastForce: 1,
                        numberOfParticles: 10,
                        blastDirectionality:
                            confetti.BlastDirectionality.directional,
                        blastDirection: pi / 2,
                        createParticlePath: (size) {
                          // Draw a down arrow
                          var path = Path();
                          path.addRRect(RRect.fromRectAndRadius(
                              Rect.fromLTWH(0, 0, size.width, size.height),
                              Radius.circular(size.width / 2)));
                          return path;
                        },
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          MarkdownBody(data: content.body!),
          OutlinedButton(
            onPressed: client != null ? () => openRespondContent() : null,
            child: const Text("Responder"),
          ),
          ...(content.children ?? [])
              .map((e) => ContentView(content: e))
              .toList(),
        ],
      ),
    );
  }

  openRespondContent() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        pageBuilder: (context, _, __) => RespondContent(
          content: content,
          onFinish: (content) {
            setState(() {
              this.content.children!.add(content);
            });
          },
        ),
      ),
    );
  }
}

class RespondContent extends StatefulWidget {
  final Content content;
  final Function(Content content) onFinish;
  const RespondContent(
      {Key? key, required this.content, required this.onFinish})
      : super(key: key);

  @override
  State<RespondContent> createState() => _RespondContentState();
}

class _RespondContentState extends State<RespondContent> {
  TextEditingController controller = TextEditingController();
  bool sending = false;
  void comment(TabNewsClient client) {
    setState(() => sending = true);

    client
        .createContent(
      body: controller.value.text,
      parentId: widget.content.id,
    )
        .catchError((e) {
      setState(() => sending = false);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${e["message"]} ${e["action"]}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: Colors.redAccent,
      ));
    }).then((content) {
      widget.onFinish(content);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    var session = context.watch<SessionState>().session;
    var client = session != null ? TabNewsClient(session) : null;
    return Scaffold(
      appBar: AppBar(title: const Text("Respondendo comentário"), actions: [
        IconButton(
          onPressed: client != null && !sending ? () => comment(client) : null,
          icon: const Icon(Icons.check),
        ),
      ]),
      body: TextField(
        controller: controller,
        expands: true,
        maxLines: null,
        textAlignVertical: TextAlignVertical.top,
        decoration: const InputDecoration(
          hintText: "Escreva aqui o seu comentário (markdown)",
          border: InputBorder.none,
        ),
        autofocus: true,
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

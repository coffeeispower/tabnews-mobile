import 'dart:math';

import 'package:flutter/material.dart';
import "package:flutter_markdown/flutter_markdown.dart";
import 'package:provider/provider.dart';
import 'package:tabnews_flutter/client/client.dart';
import 'package:tabnews_flutter/components/content/root_content_text_editor.dart';
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
  bool deleted = false;
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

  void upvoteButtonOnPress(SessionState sessionState, TabNewsClient client) {
    setState(() {
      voting = true;
    });
    client.upvote(content).then((v) {
      setState(() {
        content.tabcoins += 1;
        voting = false;
        upvoteConfettiController.play();
      });
      sessionState.fetchUser();
    }).catchError((e) {
      setState(() {
        voting = false;
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

  void downvoteButtonOnPress(SessionState sessionState, TabNewsClient client) {
    setState(() {
      voting = true;
    });
    content.downvote(client).then((v) {
      setState(() {
        content.tabcoins -= 1;
        voting = false;
        downvoteConfettiController.play();
      });
      sessionState.fetchUser();
    }).catchError((e) {
      setState(() {
        voting = false;
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
    if (deleted) {
      return const SizedBox.shrink();
    }
    var sessionState = context.watch<SessionState>();
    var session = sessionState.session;
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
                            : () => upvoteButtonOnPress(sessionState, client),
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
                            : () => downvoteButtonOnPress(sessionState, client),
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
              ),
            ],
          ),
          MarkdownBody(data: content.body!),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed:
                      client != null ? () => openRespondContent(client) : null,
                  child: const Text("Responder"),
                ),
                const Spacer(),
                if (sessionState.canUpdatePost(content)) ...[
                  IconButton(
                      onPressed: () {
                        openEditContent(client!);
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Deletar"),
                          content: const Text(
                            "Tem certeza que deseja deletar este comentário?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                deleteContent(client!);
                              },
                              child: const Text("Deletar"),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                  ),
                ]
              ],
            ),
          ),
          ...(content.children ?? [])
              .map((e) => ContentView(content: e))
              .toList(),
        ],
      ),
    );
  }

  Future<void> onCommentFinish(TabNewsClient client, String body) async {
    await client
        .createContent(
      body: body,
      parentId: widget.content.id,
    )
        .catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${e["message"]} ${e["action"]}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: Colors.redAccent,
      ));
    }).then(
      (content) {
        setState(() => this.content.children!.add(content));
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> onContentEditFinish(TabNewsClient client,
      {String? body, String? title}) async {
    var newContent = await client
        .editContent(title: title, body: body, contentToEdit: content)
        .catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${e["message"]} ${e["action"]}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: Colors.redAccent,
      ));
    });

    setState(() {
      content = content.copyWith(
        body: newContent.body,
        title: newContent.title,
      );
    });

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  openEditContent(TabNewsClient client) {
    if (content.isComment()) {
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
          pageBuilder: (context, _, __) => CommentTextEditor(
              initialBody: content.body!,
              title: "Editar",
              onFinish: ((body) => onContentEditFinish(client, body: body))),
        ),
      );
    } else {
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
          pageBuilder: (context, _, __) => RootContentTextEditor(
              initialBody: content.body!,
              editorTitle: "Editar",
              initialTitle: content.title ?? "",
              onFinish: ((title, body) async =>
                  await onContentEditFinish(client, title: title, body: body))),
        ),
      );
    }
  }

  openRespondContent(TabNewsClient client) {
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
        pageBuilder: (context, _, __) => CommentTextEditor(
            onFinish: ((body) async => await onCommentFinish(client, body))),
      ),
    );
  }

  void deleteContent(TabNewsClient client) {
    client.deleteContent(content).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Conteúdo deletado com sucesso",
          ),
        ),
      );
      setState(() {
        deleted = true;
      });
      if (!content.isComment()) {
        Navigator.of(context).pop();
      }
    }).catchError((e) {
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
  }
}

class CommentTextEditor extends StatefulWidget {
  final Future<void> Function(String body) onFinish;
  final String title;
  final String initialBody;
  const CommentTextEditor({
    Key? key,
    required this.onFinish,
    this.title = "Responder comentário",
    this.initialBody = "",
  }) : super(key: key);

  @override
  State<CommentTextEditor> createState() => _CommentTextEditorState();
}

class _CommentTextEditorState extends State<CommentTextEditor> {
  late TextEditingController controller;
  bool sending = false;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialBody);
  }

  @override
  Widget build(BuildContext context) {
    var session = context.watch<SessionState>().session;
    var client = session != null ? TabNewsClient(session) : null;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(
          onPressed: client != null && !sending
              ? () {
                  setState(() {
                    sending = true;
                  });
                  widget
                      .onFinish(controller.value.text)
                      .then((_) => setState(() => sending = false))
                      .catchError((_) => setState(() => sending = false));
                }
              : null,
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

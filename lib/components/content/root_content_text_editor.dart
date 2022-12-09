import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabnews_flutter/client/client.dart';
import 'package:tabnews_flutter/main.dart';

class RootContentTextEditor extends StatefulWidget {
  final Future<void> Function(String title, String body) onFinish;
  final String editorTitle;
  final String initialTitle;
  final String initialBody;
  const RootContentTextEditor({
    Key? key,
    required this.onFinish,
    required this.editorTitle,
    this.initialBody = "",
    this.initialTitle = "",
  }) : super(key: key);

  @override
  State<RootContentTextEditor> createState() => _RootContentTextEditorState();
}

class _RootContentTextEditorState extends State<RootContentTextEditor> {
  late TextEditingController bodyController;
  late TextEditingController titleController;
  bool sending = false;
  @override
  void initState() {
    super.initState();
    bodyController = TextEditingController(text: widget.initialBody);
    titleController = TextEditingController(text: widget.initialTitle);
  }

  @override
  Widget build(BuildContext context) {
    var session = context.watch<SessionState>().session;
    var client = session != null ? TabNewsClient(session) : null;
    return Scaffold(
      appBar: AppBar(title: Text(widget.editorTitle), actions: [
        IconButton(
          onPressed: client != null && !sending
              ? () {
                  setState(() {
                    sending = true;
                  });
                  widget
                      .onFinish(
                        titleController.value.text,
                        bodyController.value.text,
                      )
                      .then((_) => setState(() => sending = false))
                      .catchError((_) => setState(() => sending = false));
                }
              : null,
          icon: const Icon(Icons.check),
        ),
      ]),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Título",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: bodyController,
              maxLines: null,
              minLines: 3,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: "Escreva aqui o seu conteúdo (markdown)",
              ),
              autofocus: true,
            ),
          ),
        ],
      ),
    );
  }
}

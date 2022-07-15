import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class Markdown extends StatelessWidget {
  const Markdown(this.body) : super(key: null);
  final String body;
  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      // CHAOS ALLERT!
      data: body
          .replaceAll(RegExp("\\<(\\/)?(bold|strong)\\>"), "**")
          .replaceAll(RegExp("\\<h1\\>"), "# ")
          .replaceAll(RegExp("\\<h2\\>"), "## ")
          .replaceAll(RegExp("\\<h3\\>"), "### ")
          .replaceAll(RegExp("\\<h4\\>"), "#### ")
          .replaceAll(RegExp("\\<h5\\>"), "##### ")
          .replaceAll(RegExp("\\<h6\\>"), "###### ")
          .replaceAll(RegExp("\\<\\/*.\\>"), ""),
      inlineSyntaxes: [md.InlineHtmlSyntax()],
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        blockquote: const TextStyle(color: Colors.transparent),
        blockquotePadding: const EdgeInsets.all(10),
        blockquoteDecoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness.name == "light"
              ? Colors.grey[300]
              : Colors.grey[900],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        code: const TextStyle(
            backgroundColor: Colors.transparent, fontFamily: "monospace"),
        codeblockPadding: const EdgeInsets.all(10),
        codeblockDecoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness.name == "light"
              ? Colors.grey[300]
              : Colors.grey[900],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

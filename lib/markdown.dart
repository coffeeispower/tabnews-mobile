import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

Widget markdown(String markdown) {
  return MarkdownBody(
    // CHAOS ALLERT!
    data: markdown
        .replaceAll(RegExp("\\<(\\/)?(bold|strong)\\>"), "**")
        .replaceAll(RegExp("\\<h1\\>"), "# ")
        .replaceAll(RegExp("\\<h2\\>"), "## ")
        .replaceAll(RegExp("\\<h3\\>"), "### ")
        .replaceAll(RegExp("\\<h4\\>"), "#### ")
        .replaceAll(RegExp("\\<h5\\>"), "##### ")
        .replaceAll(RegExp("\\<h6\\>"), "###### ")
        .replaceAll(RegExp("\\<\\/*.\\>"), ""),
    inlineSyntaxes: [md.InlineHtmlSyntax()],
    styleSheet: MarkdownStyleSheet(
      h1: const TextStyle(fontWeight: FontWeight.bold),
      h2: const TextStyle(fontWeight: FontWeight.bold),
      h3: const TextStyle(fontWeight: FontWeight.bold),
      h4: const TextStyle(fontWeight: FontWeight.bold),
      h5: const TextStyle(fontWeight: FontWeight.bold),
      h6: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

import 'package:flutter/material.dart';

import '../../client/entities/content.dart';
import 'page.dart';

class ContentListItem extends StatelessWidget {
  final Content content;
  final int index;

  const ContentListItem(
      {super.key, required this.index, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          onTap: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ContentPage(content.title!, content.owner_username, content.slug)))
          },
          key: super.key,
          title: Text("$index. ${content.title}"),
          subtitle: Text(
              "${content.tabcoins} tabcoins · ${content.children_deep_count} comentários · ${content.owner_username}"),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(10.0),
        ));
  }
}

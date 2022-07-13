import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabnews/post.dart';
import 'package:http/http.dart' as http;
import 'package:tabnews/post_screen.dart';

import 'get_contents.dart';

class PostEntry extends StatefulWidget {
  String username;
  String slug;
  late Future<Post> post;
  Post initialPost;
  PostEntry(
      {super.key,
      required this.username,
      required this.slug,
      required this.initialPost});
  @override
  PostEntryState createState() {
    return PostEntryState();
  }
}

class PostEntryState extends State<PostEntry> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.only(top: 15.0, left: 21, right: 21),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Text(
            widget.initialPost.title,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        subtitle: Text(
          "${widget.initialPost.tabcoins} tabcoins · ${widget.initialPost.children_deep_count} comentário${widget.initialPost.children_deep_count != 1 ? "s" : ""} · ${widget.initialPost.username}",
          style: const TextStyle(fontSize: 13),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostScreen(
                      username: widget.username, slug: widget.slug)));
        });
  }
}

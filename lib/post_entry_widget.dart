import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabnews/post.dart';
import 'package:http/http.dart' as http;

import 'get_contents.dart';

class PostEntry extends StatefulWidget {
  String username;
  String slug;
  late Future<Post> post;
  Post? initialPost;
  PostEntry(
      {super.key,
      required this.username,
      required this.slug,
      this.initialPost}) {
    post = fetchPost(username, slug);
  }
  @override
  PostEntryState createState() {
    return PostEntryState();
  }
}

class PostEntryState extends State<PostEntry> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          var post = snapshot.data != null
              ? snapshot.data! as Post
              : widget.initialPost;
          if (post != null) {
            return ListTile(
                contentPadding:
                    const EdgeInsets.only(top: 15.0, left: 21, right: 21),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    post.title,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                subtitle: Text(
                  "${post.tabcoins} tabcoins · ${post.children_deep_count} comentário${post.children_deep_count != 1 ? "s" : ""} · ${post.username}",
                  style: const TextStyle(fontSize: 13),
                ),
                onTap: post == widget.initialPost ? null : () {});
          }

          return const LinearProgressIndicator();
        },
        future: widget.post);
  }
}

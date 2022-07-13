import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabnews/post.dart';
import 'package:http/http.dart' as http;

class PostEntry extends StatefulWidget {
  final Post post;
  const PostEntry({super.key, required this.post});
  @override
  PostEntryState createState() {
    return PostEntryState(post: post);
  }
}

class PostEntryState extends State<PostEntry> {
  PostEntryState({required this.post});
  Post post;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer){
      http.get(Uri.parse('https://tabnews.com.br/api/v1/contents/${post.username}/${post.slug}'))
        .then((res) {
	  if(!mounted) return;
	  setState(() {
	    post = Post.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
	  });
	});
    });

  }
  @override
  dispose() {
    super.dispose();
    timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.only(top: 15.0, left: 21, right: 21),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Text(
            post.title,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        subtitle: Text(
          "${post.tabcoins} tabcoins · ${post.children_deep_count} comentários · ${post.username}",
          style: const TextStyle(fontSize: 13),
        ),
        onTap: () {});
  }
}

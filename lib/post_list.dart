import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tabnews/get_contents.dart';

import 'post.dart';
import 'post_entry_widget.dart';
class PostList extends StatefulWidget {
  const PostList({super.key});
  @override
  PostListState createState(){
    return PostListState();
  }
}
class PostListState extends State<PostList> {
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if(!mounted) return;
      setState((){});
    });
  }
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post> posts = snapshot.data! as List<Post>;
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostEntry(post: posts[index]);
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Poxa! Não foi possivel carregar os posts!'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tabnews/get_contents.dart';

import 'post.dart';
import 'post_entry_widget.dart';

class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

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
                var username = posts[index].username;
                var slug = posts[index].slug;
                return PostEntry(
                    key: Key(username + slug + index.toString()),
                    username: username,
                    slug: slug);
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

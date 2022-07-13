import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tabnews/get_contents.dart';

import 'post.dart';
import 'post_entry_widget.dart';

class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PostListState();
  }
}

class PostListState extends State<PostList> {
  late List<Post> _posts;
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _posts = snapshot.data! as List<Post>;
            return RefreshIndicator(
                onRefresh: () async {
                  var newPosts = await fetchPosts();
                  setState(() {
                    _posts = newPosts;
                  });
                },
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    var username = _posts[index].username;
                    var slug = _posts[index].slug;
                    return PostEntry(
                        key: Key(username + slug + index.toString()),
                        username: username,
                        slug: slug,
                        initialPost: _posts[index]);
                  },
                ));
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

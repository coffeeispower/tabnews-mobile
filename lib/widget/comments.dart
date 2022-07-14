import 'package:flutter/material.dart';
import '../data_structures/post.dart';
import "../markdown.dart";
import "../api/fetch_api.dart";

class CommentsLoader extends StatelessWidget {
  final String username, slug;
  const CommentsLoader({super.key, required this.username, required this.slug});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var comments = snapshot.data! as List<Post>;
          return Comments(comments: comments);
        }
        if (snapshot.hasError) {
          return const Center(
              child: Text("Não foi possivel carregar os comentários!"));
        }
        return const Center(child: CircularProgressIndicator());
      },
      future: fetchChildren(username, slug),
    );
  }
}

class Comments extends StatelessWidget {
  final List<Post> comments;
  const Comments({super.key, required this.comments});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var comment = comments[index];
        return Comment(comment: comment);
      },
    );
  }
}

class Comment extends StatelessWidget {
  const Comment({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final Post comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Username(username: comment.username),
            markdown(comment.body!),
            Comments(comments: comment.children!)
          ],
        ),
      ),
    );
  }
}

class Username extends StatelessWidget {
  const Username({
    Key? key,
    required this.username,
  }) : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey[700],
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
  }
}

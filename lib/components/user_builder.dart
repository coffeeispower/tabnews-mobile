import 'package:flutter/material.dart';
import 'package:tabnews_flutter/client/client.dart';
import 'package:tabnews_flutter/client/entities/auth.dart';

import '../client/entities/user.dart';

class UserBuilder extends StatelessWidget {
  final Function(BuildContext, User) builder;
  final Session session;

  const UserBuilder({super.key, required this.builder, required this.session});

  @override
  Widget build(BuildContext context) {
    var client = TabNewsClient(session);
    return FutureBuilder(
      future: client.getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Verifique sua conexão: ${snapshot.error}"));
        }
        if (snapshot.hasData) {
          return builder(context, snapshot.data!);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}


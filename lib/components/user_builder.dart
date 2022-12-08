import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabnews_flutter/main.dart';

import '../client/entities/user.dart';

class UserBuilder extends StatelessWidget {
  final Function(BuildContext, User) builder;

  const UserBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<SessionState>().fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text("Verifique sua conexão: ${snapshot.error}"));
        }
        if (snapshot.hasData) {
          return builder(context, snapshot.data as User);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

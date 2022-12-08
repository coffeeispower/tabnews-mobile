import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabnews_flutter/client/client.dart';
import 'package:tabnews_flutter/components/alert_box.dart';
import 'package:tabnews_flutter/components/user_builder.dart';
import 'package:tabnews_flutter/main.dart';

import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  bool? enable_notifications;
  TextEditingController? username;
  TextEditingController? email;
  bool saving = false;

  dynamic error;

  @override
  Widget build(BuildContext context) {
    var sessionState = context.watch<SessionState>();
    var session = sessionState.session;

    if (sessionState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Perfil")),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (session == null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Você não está logado!"),
              ElevatedButton(
                child: const Text("Login"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
              )
            ],
          ),
        );
      }

      var client = TabNewsClient(session);
      return UserBuilder(
        builder: (context, user) {
          enable_notifications ??= user.notifications;
          username ??= TextEditingController(text: user.username);
          email ??= TextEditingController(text: user.email);
          return StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (error != null) AlertBox.fromError(error),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 0.0,
                        ),
                        child: Text("Nome de usuário",
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      TextField(
                        controller: username,
                        enabled: !saving,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 0.0),
                        child: Text("Email",
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      TextField(
                        enabled: !saving,
                        controller: email,
                      ),
                      CheckboxListTile(
                        value: enable_notifications,
                        enabled: !saving,
                        onChanged: (n) {
                          setState(() {
                            enable_notifications = n ?? false;
                          });
                        },
                        title: const Text("Receber notificações por email"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      if (!saving)
                        Center(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                saving = true;
                              });
                              var usernameChanged =
                                  user.username != username!.value.text;
                              var emailChanged =
                                  user.email != email!.value.text;
                              client
                                  .editProfile(
                                username: usernameChanged
                                    ? username?.value.text
                                    : null,
                                email: emailChanged ? email?.value.text : null,
                                notifications: enable_notifications,
                              )
                                  .then((a) {
                                setState(() {
                                  error = null;
                                  saving = false;
                                  sessionState.fetchUser();
                                });
                              }).catchError((e) {
                                setState(() {
                                  error = e;
                                  saving = false;
                                });
                              });
                            },
                            child: const Text("Salvar"),
                          ),
                        ),
                      if (saving)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}

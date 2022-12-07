import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabnews_flutter/client/client.dart';
import 'package:tabnews_flutter/client/entities/auth.dart';
import 'package:tabnews_flutter/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}
class LoginPageState extends State<StatefulWidget> {
  TextEditingController emailController = TextEditingController(),  passwordController = TextEditingController();
  bool loggingIn = false;
  @override
  Widget build(BuildContext context) {
    var sessionState = context.read<SessionState>();
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            elevation: 20.0,
            margin: const EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(icon: Icon(Icons.email_outlined), labelText: "Email"),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(icon: Icon(Icons.password), labelText: "Password"),
                      obscureText: true,
                    ),
                  ),
                  if(!loggingIn)
                  ElevatedButton(
                    onPressed: () {

                      setState(() {
                        loggingIn = true;
                      });
                      TabNewsClient.login(LoginRequest(email: emailController.value.text, password: passwordController.value.text)).then((session) {
                        TabNewsClient.saveSession(session);
                        sessionState.setSession(session);
                        setState(() {
                          loggingIn = false;
                        });
                        Navigator.pop(context);
                      });

                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text("Entrar"),
                    ),
                  ) else const ElevatedButton(
                    onPressed: null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: CircularProgressIndicator()
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
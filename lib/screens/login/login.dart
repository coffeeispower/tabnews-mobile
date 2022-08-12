// Login Screen widget in flutter

import 'package:flutter/material.dart';
import 'package:tabnews/api/login.dart';
import 'package:tabnews/components/appbar/appbar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggingIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title with padding
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        enabled: !_isLoggingIn,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                        validator: (email) {
                          if (email != null && email.isEmpty) {
                            return 'Esse campo é obrigatório!';
                          }
                          if (!email!.contains('@')) {
                            return 'Esse email não é válido!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        enabled: !_isLoggingIn,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Esse campo é obrigatório!';
                          }
                          if (value!.length < 8) {
                            return 'Esse campo deve ter no mínimo 8 caracteres!';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: !_isLoggingIn
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                // Logs in the user using the api
                                // If the user is logged in, it will redirect to the home screen
                                // If the user is not logged in, it will show an error message
                                setState(() {
                                  _isLoggingIn = true;
                                });
                                await login(_emailController.text,
                                        _passwordController.text)
                                    .catchError((e) async {
                                  setState(() {
                                    _isLoggingIn = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString(),
                                            style: const TextStyle(
                                                color: Colors.white)),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  });
                                });
                                setState(() {
                                  _isLoggingIn = false;
                                });
                                Navigator.pop(context);
                              }
                            }
                          : null,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Entrar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

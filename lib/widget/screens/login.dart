// Login Screen widget in flutter

import 'package:flutter/material.dart';
import 'package:tabnews/api/login.dart';
import 'package:tabnews/widget_factories/appbar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _isLoggingIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              enabled: !_isLoggingIn,
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (email) {
                if (email != null && email.isEmpty) {
                  return 'Esse campo é obrigatório!';
                }
                return null;
              },
            ),
            TextFormField(
              enabled: !_isLoggingIn,
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Esse campo é obrigatório!';
                }
                return null;
              },
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
                        await login(
                                _emailController.text, _passwordController.text)
                            .catchError((e) {
                          setState(() {
                            _error = e.toString();
                            _isLoggingIn = false;
                          });
                        });
                        setState(() {
                          _isLoggingIn = false;
                        });
                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: const Text('Login'),
            ),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

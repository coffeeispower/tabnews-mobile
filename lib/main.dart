import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import modules
import 'package:tabnews/api/login.dart';
import 'package:tabnews/screens/home/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureProvider<User?>(
      initialData: null,
      create: (_) => fetchUser(),
      child: const MaterialApp(
        title: 'TabNews',
        home: Home(title: "Home"),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

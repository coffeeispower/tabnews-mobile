import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabNews',
      theme: ThemeData.light(),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.black),
      home: const Home(title: "Home"),
    );
  }
}

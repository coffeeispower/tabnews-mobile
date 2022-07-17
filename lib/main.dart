import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabnews/api/login.dart';

import 'widget/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureProvider<User?>(
      initialData: null,
      create: (_) => fetchUser(),
      child: MaterialApp(
        title: 'TabNews',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.white,
          ),
        ),
        darkTheme: ThemeData(
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.black,
          ),
          brightness: Brightness.dark,
        ),
        home: const Home(title: "Home"),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

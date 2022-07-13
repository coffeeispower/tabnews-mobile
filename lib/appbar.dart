import 'package:flutter/material.dart';

AppBar app_bar() {
  return AppBar(
      title: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Image.asset("assets/favicon-dark.png", width: 30)),
          const Text("TabNews")
        ],
      ),
      elevation: 0);
}

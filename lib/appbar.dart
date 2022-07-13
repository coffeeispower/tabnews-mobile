import 'package:flutter/material.dart';

AppBar app_bar() {
  return AppBar(
      title: Flex(
        direction: Axis.horizontal,
        children: [
          Image.asset(
            "assets/favicon-dark.png",
            width: 40,
            height: 40,
          ),
          const Text("TabNews")
        ],
      ),
      elevation: 0);
}

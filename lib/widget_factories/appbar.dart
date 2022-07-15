import 'package:flutter/material.dart';

AppBar appbar(BuildContext context) {
  return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(
              "assets/favicon-${MediaQuery.of(context).platformBrightness.name}.png",
              width: 35,
              height: 35,
            ),
          ),
          const Text("TabNews"),
        ],
      ),
      elevation: 0);
}

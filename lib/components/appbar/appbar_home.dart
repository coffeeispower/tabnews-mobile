import 'package:flutter/material.dart';

//import modules
import 'package:tabnews/components/appbar/pop_upmenubutton.dart';

AppBar appbar_home(BuildContext context) {
  return AppBar(
    centerTitle: false,
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
    actions: [
      popupMenuButton(context),
    ],
    backgroundColor: const Color.fromARGB(255, 37, 54, 63),
    elevation: 0,
  );
}

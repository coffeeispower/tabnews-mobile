import 'package:flutter/material.dart';

//import modules
import 'package:tabnews/components/appbar/pop_upmenubutton.dart';

AppBar AppbarConfigPage(BuildContext context) {
  return AppBar(
    centerTitle: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        Text("Configurações"),
      ],
    ),
    backgroundColor: const Color.fromARGB(255, 37, 54, 63),
    elevation: 0,
  );
}

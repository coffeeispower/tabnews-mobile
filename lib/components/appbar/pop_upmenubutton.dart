// ignore: file_names
import 'package:flutter/material.dart';

//import modules
import 'package:tabnews/api/login.dart';
import 'package:tabnews/screens/login/login.dart';

//list of items
enum Menu { itemOne, itemTwo, itemThree, itemFour }

void setState(Null Function() param0) {}

PopupMenuButton popupMenuButton(BuildContext context) {
  return PopupMenuButton<Menu>(
    // Callback that sets the selected popup menu item.
    onSelected: (Menu item) async {
      switch (item.name) {
        //Menu --> go to the new content to publish page
        case 'itemOne':
          if (!await isLoggedIn()) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          } else {}
          break;
        //Menu --> go to the page that shows the contents of the user
        case 'itemTwe':
          if (!await isLoggedIn()) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          } else {}
          break;
        //Menu --> go to the config page
        case 'itemThree':
          break;
      }
    },

    //Show list of items to select
    itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
      const PopupMenuItem<Menu>(
        value: Menu.itemOne,
        child: Text('Publicar novo conteúdo'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.itemTwo,
        child: Text('Suas publicações'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.itemThree,
        child: Text('Conta'),
      ),
    ],
  );
}

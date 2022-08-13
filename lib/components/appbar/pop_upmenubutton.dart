// ignore: file_names
import 'package:flutter/material.dart';

//import modules
import 'package:tabnews/api/login_api.dart';
import 'package:tabnews/screens/login/login.dart';
import 'package:tabnews/screens/config_page/config_page.dart';

//list of items
enum Menu { itemOne, itemTwo, itemThree, itemFour }

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
        case 'itemTwo':
          if (!await isLoggedIn()) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          } else {}
          break;
        //Menu --> go to the config page
        case 'itemThree':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConfigPage()),
          );
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
        child: Text('Configurações'),
      ),
    ],
  );
}

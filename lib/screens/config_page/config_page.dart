import 'package:flutter/material.dart';

import 'package:tabnews/components/appbar/appbar_config.dart';
import 'package:tabnews/data_structures/openBrowserUrl.dart';
import 'package:tabnews/components/showdialog/showDialogSet.dart';

String url =
    "https://www.tabnews.com.br/filipedeschamps/tentando-construir-um-pedaco-de-internet-mais-massa";

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarConfigPage(context),
      body: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              leading: Icon(Icons.brightness_6),
              title: const Text(
                "Tema",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () => showMyDialog(context),
            ),
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
          ),
          Container(
            child: ListTile(
              leading: const Icon(Icons.web),
              title: const Text(
                "Site oficial do TabNews",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () async {
                openBrowserUrl(Url: url);
              },
            ),
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
          ),
          Container(
            child: ListTile(
              leading: Icon(Icons.info),
              title: const Text(
                "Sobre o App",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () => showMyDialog(context),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

Future<void> showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('TabNews'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                "Recurso ainda não implementado.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)),
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void setState(Null Function() param0) {}

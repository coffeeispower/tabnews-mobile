import 'package:flutter/material.dart';

class AlertBox extends StatefulWidget {
  const AlertBox({super.key, required this.message, required this.action});
  final String message;
  final String action;
  factory AlertBox.fromError(dynamic e, {key}) {
    return AlertBox(key: key, message: e["message"], action: e["action"]);
  }
  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red[600]!,
        border: Border.all(
          color: Colors.red[400]!,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.message),
          Text(widget.action),
        ],
      ),
    );
  }
}

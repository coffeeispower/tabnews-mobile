import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future openBrowserUrl({required String Url}) async {
  final Uri _url = Uri.parse(Url);
  if (!await canLaunchUrl(_url)) {
    await launchUrl(_url, mode: LaunchMode.externalApplication);
  }
}

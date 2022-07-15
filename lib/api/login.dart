import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Checks if expires_at dat is on the future
Future<bool> isLoggedIn() async {
  final storage = FlutterSecureStorage();
  if (await storage.read(key: "token") == null) {
    return false;
  }
  final expiresAt = await storage.read(key: "expires_at");
  return expiresAt != null && DateTime.parse(expiresAt).isAfter(DateTime.now());
}

/* Logs into tabnews.com.br with email and password and stores the token */
Future<String> login(String email, String password) async {
  final storage = FlutterSecureStorage();
  final response = await http.post(
    Uri.parse('https://www.tabnews.com.br/api/v1/sessions'),
    headers: {
      "Accept": "application/json",
    },
    body: {
      'email': email,
      'password': password,
    },
  );
  if (response.statusCode == 201) {
    // Parse the body as json and extract the token
    final token = jsonDecode(response.body)['token'];
    // Store the token in the secure storage
    await storage.write(key: 'token', value: token);
    // Save the expires_at date in the secure storage
    await storage.write(
      key: 'expires_at',
      value: jsonDecode(response.body)['expires_at'],
    );
    return token;
  } else {
    // Get message from the body
    final response_body = jsonDecode(response.body);
    final action = response_body["action"];
    final message = response_body["message"];
    throw "Login falhou: $message: $action";
  }
}

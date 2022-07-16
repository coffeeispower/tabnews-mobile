import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Checks if expires_at dat is on the future
Future<bool> isLoggedIn() async {
  const storage = FlutterSecureStorage();
  if (await storage.read(key: "token") == null) {
    return false;
  }
  final expiresAt = await storage.read(key: "expires_at");
  return expiresAt != null && DateTime.parse(expiresAt).isAfter(DateTime.now());
}

/* Logs into tabnews.com.br with email and password and stores the token */
Future<String> login(String email, String password) async {
  const storage = FlutterSecureStorage();
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
    throw "Login falhou: $message $action";
  }
}

class User {
  final String id;
  final String username;
  final String email;
  final List<String> features;
  final int tabcoins;
  final int tabcash;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.features,
    required this.tabcoins,
    required this.tabcash,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      features: json['features'].cast<String>(),
      tabcoins: json['tabcoins'],
      tabcash: json['tabcash'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

Future<User> fetchUser() async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: "token");
  if (token == null) {
    throw "Não está logado";
  }
  final response = await http.get(
    Uri.parse('https://www.tabnews.com.br/api/v1/user'),
    headers: {
      "Accept": "application/json",
      "Cookie": "session_id=$token",
    },
  );
  if (response.statusCode == 200) {
    final user = User.fromJson(jsonDecode(response.body));
    return user;
  } else {
    throw "Erro ao obter usuário";
  }
}

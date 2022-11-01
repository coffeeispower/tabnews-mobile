import 'dart:convert';

import 'package:http/http.dart' as http;
import "constants.dart" as constants;
import 'package:json_annotation/json_annotation.dart';
part "auth.g.dart";
@JsonSerializable()
class LoginRequest {
  final String email, password;
  LoginRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}
@JsonSerializable()
class Session {
  final String id, token;
  @JsonKey(name: "expires_at")
  final DateTime expiresAt;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  Session({required this.id, required this.token, required this.expiresAt, required this.createdAt, required this.updatedAt});
  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
Future<Session> login(LoginRequest loginRequest) async {
  var client = http.Client();
  var response = await client.post(
      Uri.https(constants.baseUrl, "/sessions"),
      body: loginRequest.toJson()
  );
  if (response.statusCode != 201) {
    return Future.error(Exception(response.statusCode));
  }
  var json = jsonDecode(response.body);
  var session = Session.fromJson(json);
  return session;
}
Future<void> recoveryByUsername(String username) async {
  var client = http.Client();
  var response = await client.post( 
      Uri.https(constants.baseUrl, "/recovery"),
      body: {username: username}
  );
  if (response.statusCode != 201) {
    return Future.error(Exception(response.statusCode));
  }
}

Future<void> recoveryByEmail(String email) async {
  var client = http.Client();
  var response = await client.post(
      Uri.https(constants.baseUrl, "/recovery"),
      body: {email: email}
  );
  if (response.statusCode != 201) {
    return Future.error(Exception(response.statusCode));
  }
}
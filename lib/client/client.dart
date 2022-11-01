import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:tabnews_flutter/client/constants.dart';
import 'package:tabnews_flutter/client/entities/content.dart';

import 'entities/user.dart';

class TabNewsClient {
  final String sessionId;
  static final http.Client client = http.Client();

  TabNewsClient(this.sessionId);

  Map<String, String> authHeaders() {
    return {
      "Content-Type": "application/json",
      "Cookies": "session_id=$sessionId"
    };
  }
  static Map<String, String> headers() {
    return {
      "Content-Type": "application/json",
    };
  }
  Future<User> getUser() async {
    var response =
        await client.get(Uri.parse("$baseUrl/user"), headers: authHeaders());
    var json = jsonDecode(response.body);
    var user = User.fromJson(json);
    return user;
  }

  Future<Content> publishContent(NewContent content) async {
    var response =
        await client.post(Uri.parse("$baseUrl/contents"), headers: authHeaders());
    var json = jsonDecode(response.body);
    var content = Content.fromJson(json);
    return content;
  }

  static Future<List<Content>> listContents(int page, int perPage, Strategy strategy) async {
    var response = await client.get(Uri.parse("$baseUrl/contents?page=$page&per_page=$perPage&strategy=$strategy"),
        headers: headers());
    List<dynamic> json = jsonDecode(response.body);
    var contents = List.of(json.map((e) => Content.fromJson(e)));
    return contents;
  }
  static Future<List<Content>> getChildren(Content content) async {
    var response = await client.get(Uri.parse("$baseUrl/contents/${content.owner_username}/${content.slug}/children"),
        headers: headers());
    List<dynamic> json = jsonDecode(response.body);
    return List.of(json.map((e) => Content.fromJson(e)));
  }
  static Future<Content> getContent(String author, String slug, bool fetchChildren) async {
    var response = await client.get(Uri.parse("$baseUrl/contents/$author/$slug"),
        headers: headers());
    var json = jsonDecode(response.body);
    var content = Content.fromJson(json);
    if(fetchChildren) {
      content.children = await getChildren(content);
    }
    return content;
  }
}
enum Strategy {
  relevant("relevant"),
  newest("new"),
  old("old");
  final String value;
  const Strategy(this.value);
  @override
  String toString() {
    return value;
  }
}
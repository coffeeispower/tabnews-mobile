import 'dart:convert';
import "package:http/http.dart" as http;
import 'entities/auth.dart';
import 'constants.dart';
import 'entities/content.dart';
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

  static Future<Session> login(LoginRequest loginRequest) async {
    var response = await client.post(
        Uri.https(baseUrl, "/sessions"),
        body: loginRequest.toJson()
    );
    if (response.statusCode != 201) {
      return Future.error(Exception(response.statusCode));
    }
    var json = jsonDecode(response.body);
    var session = Session.fromJson(json);
    return session;
  }
  static Future<void> recoveryByUsername(String username) async {
    var client = http.Client();
    var response = await client.post(
        Uri.parse("$baseUrl/recovery"),
        body: {username: username}
    );
    if (response.statusCode != 201) {
      return Future.error(Exception(response.statusCode));
    }
  }

  static Future<void> recoveryByEmail(String email) async {
    var response = await client.post(
        Uri.parse("$baseUrl/recovery"),
        body: {email: email}
    );
    if (response.statusCode != 201) {
      return Future.error(Exception(response.statusCode));
    }
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
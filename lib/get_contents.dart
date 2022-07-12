import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tabnews/post.dart';
import 'package:http/http.dart' as http;

Future<List<PartialPost>> fetchPosts() async {
  var res = await http
      .get(Uri.parse('https://tabnews.com.br/api/v1/contents?strategy=best'));
  return compute(parsePosts, res.body);
}

// A function that converts a response body into a List<PartialPost>.
List<PartialPost> parsePosts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<PartialPost>((json) => PartialPost.fromJson(json)).toList();
}

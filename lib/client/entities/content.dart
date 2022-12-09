import 'package:json_annotation/json_annotation.dart';

import '../client.dart';

part "content.g.dart";

@JsonSerializable()
class Content {
  final String id, owner_id;
  final String slug, status, owner_username;
  final String? body, source_url, parent_id, title;
  final DateTime created_at, updated_at, published_at;
  final DateTime? deleted_at;
  int children_deep_count = 0;
  int tabcoins;
  List<Content>? children;
  bool isComment() => parent_id != null;
  Content(
      {required this.id,
      required this.owner_id,
      this.parent_id,
      required this.slug,
      this.title,
      required this.status,
      this.source_url,
      required this.owner_username,
      this.body,
      required this.created_at,
      required this.updated_at,
      required this.published_at,
      this.deleted_at,
      required this.tabcoins,
      this.children_deep_count = 0,
      this.children});

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
  Future<void> upvote(TabNewsClient client) async {
    await client.upvote(this);
  }

  Future<void> downvote(TabNewsClient client) async {
    await client.downvote(this);
  }

  // create copyWith
  Content copyWith({
    String? id,
    String? owner_id,
    String? slug,
    String? status,
    String? owner_username,
    String? body,
    String? source_url,
    String? parent_id,
    String? title,
    DateTime? created_at,
    DateTime? updated_at,
    DateTime? published_at,
    DateTime? deleted_at,
    int? tabcoins,
    List<Content>? children,
    int? children_deep_count,
  }) {
    return Content(
      id: id ?? this.id,
      owner_id: owner_id ?? this.owner_id,
      slug: slug ?? this.slug,
      status: status ?? this.status,
      owner_username: owner_username ?? this.owner_username,
      body: body ?? this.body,
      source_url: source_url ?? this.source_url,
      parent_id: parent_id ?? this.parent_id,
      title: title ?? this.title,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      published_at: published_at ?? this.published_at,
      deleted_at: deleted_at ?? this.deleted_at,
      tabcoins: tabcoins ?? this.tabcoins,
      children: children ?? this.children,
      children_deep_count: children_deep_count ?? this.children_deep_count,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

part "content.g.dart";

@JsonSerializable()
class Content {
  final String id, owner_id;
  final String slug, status, owner_username;
  final String? body, source_url, parent_id, title;
  final DateTime created_at, updated_at, published_at;
  final DateTime? deleted_at;
  final int tabcoins, children_deep_count;
  List<Content>? children;

  Content(
      {
        required this.id,
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
        required this.children_deep_count,
        this.children
      });

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}

@JsonSerializable()
class NewContent {
  final String title, body, source_url, status;
  final String? slug;

  NewContent({required this.title, required this.body, required this.source_url, this.status = "published", this.slug});
  Map<String, dynamic> toJson() => _$NewContentToJson(this);
}

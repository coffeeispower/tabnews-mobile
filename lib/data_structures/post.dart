class Post {
  final String id;
  final String owner_id;
  final String? parent_id;
  final String slug;
  final String? title;
  final String status;
  final String? source_url;
  final String created_at;
  final String updated_at;
  final String published_at;
  final String? deleted_at;
  final String username;
  final String? parent_title;
  final String? parent_slug;
  final String? parent_username;
  final int tabcoins;
  final int children_deep_count;
  final String? body;
  final List<Post>? children;
  const Post({
    this.children,
    this.body,
    required this.id,
    required this.owner_id,
    this.parent_id,
    required this.slug,
    required this.title,
    required this.status,
    this.source_url,
    required this.created_at,
    required this.updated_at,
    required this.published_at,
    this.deleted_at,
    required this.username,
    this.parent_title,
    this.parent_slug,
    this.parent_username,
    required this.tabcoins,
    required this.children_deep_count,
  });
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      children: json["children"]?.map<Post>((e) => Post.fromJson(e)).toList(),
      body: json["body"],
      id: json["id"],
      owner_id: json["owner_id"],
      slug: json["slug"],
      title: json["title"],
      status: json["status"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      published_at: json["published_at"],
      username: json["username"],
      tabcoins: json["tabcoins"],
      children_deep_count: json["children_deep_count"],
    );
  }
}

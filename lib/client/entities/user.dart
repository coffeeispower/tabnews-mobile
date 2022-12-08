import 'package:json_annotation/json_annotation.dart';
part "user.g.dart";

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String email;
  final bool notifications;
  final List<String> features;
  final int tabcoins, tabcash;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.features,
      required this.tabcoins,
      required this.tabcash,
      required this.createdAt,
      required this.updatedAt,
      required this.notifications});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  factory User.createAnonymous() => User(
        id: "",
        username: "",
        email: "",
        features: ['read:activation_token', 'create:session', 'create:user'],
        tabcoins: 0,
        tabcash: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        notifications: false,
      );
}

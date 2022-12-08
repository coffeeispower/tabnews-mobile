import 'package:json_annotation/json_annotation.dart';
part 'auth.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email, password;
  LoginRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
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
  Session(
      {required this.id,
      required this.token,
      required this.expiresAt,
      required this.createdAt,
      required this.updatedAt});
  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

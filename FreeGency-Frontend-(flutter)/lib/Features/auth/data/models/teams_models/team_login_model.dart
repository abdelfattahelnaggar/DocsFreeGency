import 'dart:convert';

class TeamLoginModel {
  final String? message;
  final User? user;
  final String? token;

  TeamLoginModel({
    this.message,
    this.user,
    this.token,
  });

  factory TeamLoginModel.fromRawJson(String str) =>
      TeamLoginModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TeamLoginModel.fromJson(Map<String, dynamic> json) => TeamLoginModel(
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user?.toJson(),
        "token": token,
      };
}

class User {
  final String? id;
  final String? email;
  final String? role;
  final String? name;

  User({
    this.id,
    this.email,
    this.role,
    this.name,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        role: json["role"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "role": role,
        "name": name,
      };
}

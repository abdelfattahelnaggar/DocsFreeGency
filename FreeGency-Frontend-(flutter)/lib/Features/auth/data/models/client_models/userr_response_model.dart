import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/user_model.dart';

class UserResponseModel {
  final String message;
  final UserModel user;
  final String token;

  UserResponseModel({
    required this.message,
    required this.user,
    required this.token,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      message: json['message'],
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}

// class UserData {
//   final String id;
//   final String email;
//   final String role;
//   final String name;

//   UserData({
//     required this.id,
//     required this.email,
//     required this.role,
//     required this.name,
//   });

//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       id: json['id'],
//       email: json['email'],
//       role: json['role'],
//       name: json['name'],
//     );
//   }
// }

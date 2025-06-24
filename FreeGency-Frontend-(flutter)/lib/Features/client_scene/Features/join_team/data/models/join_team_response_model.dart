class JoinTeamResponseModel {
  final String? id;
  final User? user;
  final String? job;

  JoinTeamResponseModel({
    this.id,
    this.user,
    this.job,
  });

  factory JoinTeamResponseModel.fromJson(Map<String, dynamic> json) {
    return JoinTeamResponseModel(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      job: json['job'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'job': job,
    };
  }
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? profileImage;

  User({
    this.id,
    this.name,
    this.email,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }
}

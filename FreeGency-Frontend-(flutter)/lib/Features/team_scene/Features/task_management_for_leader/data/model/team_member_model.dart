class TeamMemberModel {
  final String? id;
  final UserInfo? user;
  final String? role;
  final String? job;
  final DateTime? joinedAt;

  TeamMemberModel({
    this.id,
    this.user,
    this.role,
    this.job,
    this.joinedAt,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) => TeamMemberModel(
        id: json['_id'],
        user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
        role: json['role'],
        job: json['job'],
        joinedAt:
            json['joinedAt'] != null ? DateTime.parse(json['joinedAt']) : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user?.toJson(),
        'role': role,
        'job': job,
        'joinedAt': joinedAt?.toIso8601String(),
      };
}

class UserInfo {
  final String? id;
  final String? name;
  final String? profileImage;

  UserInfo({
    this.id,
    this.name,
    this.profileImage,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json['_id'],
        name: json['name'],
        profileImage: json['profileImage'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'profileImage': profileImage,
      };
}

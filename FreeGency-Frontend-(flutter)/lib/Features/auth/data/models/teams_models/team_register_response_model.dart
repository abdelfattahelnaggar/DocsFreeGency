import 'dart:convert';

class TeamRegisterOrCreateResponseModel {
  final String? message;
  final Data? data;

  TeamRegisterOrCreateResponseModel({
    this.message,
    this.data,
  });

  factory TeamRegisterOrCreateResponseModel.fromRawJson(String str) =>
      TeamRegisterOrCreateResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TeamRegisterOrCreateResponseModel.fromJson(
          Map<String, dynamic> json) =>
      TeamRegisterOrCreateResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final User? user;
  final Team? team;
  final String? token;

  Data({
    this.user,
    this.team,
    this.token,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        team: json["team"] == null ? null : Team.fromJson(json["team"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "team": team?.toJson(),
        "token": token,
      };
}

class Team {
  final String? teamLeader;
  final String? name;
  final String? teamCode;
  final String? category;
  final List<Member>? members;
  final Rating? rating;
  final String? status;
  final String? id;
  final List<dynamic>? joinRequests;
  final List<dynamic>? projects;
  final List<dynamic>? lastedProjects;
  final DateTime? foundedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Team({
    this.teamLeader,
    this.name,
    this.teamCode,
    this.category,
    this.members,
    this.rating,
    this.status,
    this.id,
    this.joinRequests,
    this.projects,
    this.lastedProjects,
    this.foundedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Team.fromRawJson(String str) => Team.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        teamLeader: json["teamLeader"],
        name: json["name"],
        teamCode: json["teamCode"],
        category: json["category"],
        members: json["members"] == null
            ? []
            : List<Member>.from(
                json["members"]!.map((x) => Member.fromJson(x))),
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
        status: json["status"],
        id: json["_id"],
        joinRequests: json["joinRequests"] == null
            ? []
            : List<dynamic>.from(json["joinRequests"]!.map((x) => x)),
        projects: json["projects"] == null
            ? []
            : List<dynamic>.from(json["projects"]!.map((x) => x)),
        lastedProjects: json["lastedProjects"] == null
            ? []
            : List<dynamic>.from(json["lastedProjects"]!.map((x) => x)),
        foundedAt: json["foundedAt"] == null
            ? null
            : DateTime.parse(json["foundedAt"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "teamLeader": teamLeader,
        "name": name,
        "teamCode": teamCode,
        "category": category,
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "rating": rating?.toJson(),
        "status": status,
        "_id": id,
        "joinRequests": joinRequests == null
            ? []
            : List<dynamic>.from(joinRequests!.map((x) => x)),
        "projects":
            projects == null ? [] : List<dynamic>.from(projects!.map((x) => x)),
        "lastedProjects": lastedProjects == null
            ? []
            : List<dynamic>.from(lastedProjects!.map((x) => x)),
        "foundedAt": foundedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Member {
  final String? user;
  final String? role;
  final String? job;
  final DateTime? joinedAt;
  final String? id;

  Member({
    this.user,
    this.role,
    this.job,
    this.joinedAt,
    this.id,
  });

  factory Member.fromRawJson(String str) => Member.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        user: json["user"],
        role: json["role"],
        job: json["job"],
        joinedAt:
            json["joinedAt"] == null ? null : DateTime.parse(json["joinedAt"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "role": role,
        "job": job,
        "joinedAt": joinedAt?.toIso8601String(),
        "_id": id,
      };
}

class Rating {
  final int? average;
  final int? count;

  Rating({
    this.average,
    this.count,
  });

  factory Rating.fromRawJson(String str) => Rating.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        average: json["average"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "count": count,
      };
}

class User {
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  final List<dynamic>? teams;
  final List<dynamic>? skills;
  final List<dynamic>? interests;
  final bool? isVerified;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? createdTeam;

  User({
    this.name,
    this.email,
    this.password,
    this.role,
    this.teams,
    this.skills,
    this.interests,
    this.isVerified,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.createdTeam,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        teams: json["teams"] == null
            ? []
            : List<dynamic>.from(json["teams"]!.map((x) => x)),
        skills: json["skills"] == null
            ? []
            : List<dynamic>.from(json["skills"]!.map((x) => x)),
        interests: json["interests"] == null
            ? []
            : List<dynamic>.from(json["interests"]!.map((x) => x)),
        isVerified: json["isVerified"],
        id: json["_id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        createdTeam: json["createdTeam"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
        "teams": teams == null ? [] : List<dynamic>.from(teams!.map((x) => x)),
        "skills":
            skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
        "interests": interests == null
            ? []
            : List<dynamic>.from(interests!.map((x) => x)),
        "isVerified": isVerified,
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "createdTeam": createdTeam,
      };
}

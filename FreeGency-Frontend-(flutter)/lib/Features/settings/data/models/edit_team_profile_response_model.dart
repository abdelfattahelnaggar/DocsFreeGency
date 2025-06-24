class TeamMember {
  final String user;
  final String role;
  final String job;
  final String joinedAt;
  final String id;

  TeamMember({
    required this.user,
    required this.role,
    required this.job,
    required this.joinedAt,
    required this.id,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      user: json['user'] ?? '',
      role: json['role'] ?? '',
      job: json['job'] ?? '',
      joinedAt: json['joinedAt'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'role': role,
      'job': job,
      'joinedAt': joinedAt,
      '_id': id,
    };
  }
}

class TeamContactInfo {
  final String email;
  final String phone;

  TeamContactInfo({
    required this.email,
    required this.phone,
  });

  factory TeamContactInfo.fromJson(Map<String, dynamic> json) {
    return TeamContactInfo(
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
    };
  }
}

class TeamSocialMediaLinks {
  final String? linkedin;
  final String? facebook;
  final String? website;
  final String? github;

  TeamSocialMediaLinks({
    this.linkedin,
    this.facebook,
    this.website,
    this.github,
  });

  factory TeamSocialMediaLinks.fromJson(Map<String, dynamic> json) {
    return TeamSocialMediaLinks(
      linkedin: json['linkedin'],
      facebook: json['facebook'],
      website: json['website'],
      github: json['github'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (linkedin != null) data['linkedin'] = linkedin;
    if (facebook != null) data['facebook'] = facebook;
    if (website != null) data['website'] = website;
    if (github != null) data['github'] = github;
    return data;
  }
}

class TeamData {
  final TeamContactInfo contactInfo;
  final TeamSocialMediaLinks socialMediaLinks;
  final String id;
  final String teamLeader;
  final String logo;
  final String name;
  final String teamCode;
  final String category;
  final List<TeamMember> members;
  final List<String> skills;
  final List<dynamic> projects;
  final List<dynamic> ratings;
  final double averageRating;
  final int ratingCount;
  final String status;
  final List<dynamic> joinRequests;
  final List<dynamic> clientTasks;
  final String foundedAt;
  final String createdAt;
  final String updatedAt;
  final int version;
  final String aboutUs;

  TeamData({
    required this.contactInfo,
    required this.socialMediaLinks,
    required this.id,
    required this.teamLeader,
    required this.logo,
    required this.name,
    required this.teamCode,
    required this.category,
    required this.members,
    required this.skills,
    required this.projects,
    required this.ratings,
    required this.averageRating,
    required this.ratingCount,
    required this.status,
    required this.joinRequests,
    required this.clientTasks,
    required this.foundedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.aboutUs,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      contactInfo: TeamContactInfo.fromJson(json['contactInfo'] ?? {}),
      socialMediaLinks:
          TeamSocialMediaLinks.fromJson(json['socialMediaLinks'] ?? {}),
      id: json['_id'] ?? '',
      teamLeader: json['teamLeader'] ?? '',
      logo: json['logo'] ?? '',
      name: json['name'] ?? '',
      teamCode: json['teamCode'] ?? '',
      category: json['category'] ?? '',
      members: (json['members'] as List<dynamic>?)
              ?.map((member) => TeamMember.fromJson(member))
              .toList() ??
          [],
      skills: List<String>.from(json['skills'] ?? []),
      projects: json['Projects'] ?? [],
      ratings: json['ratings'] ?? [],
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
      status: json['status'] ?? '',
      joinRequests: json['joinRequests'] ?? [],
      clientTasks: json['clientTasks'] ?? [],
      foundedAt: json['foundedAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      version: json['__v'] ?? 0,
      aboutUs: json['aboutUs'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactInfo': contactInfo.toJson(),
      'socialMediaLinks': socialMediaLinks.toJson(),
      '_id': id,
      'teamLeader': teamLeader,
      'logo': logo,
      'name': name,
      'teamCode': teamCode,
      'category': category,
      'members': members.map((member) => member.toJson()).toList(),
      'skills': skills,
      'Projects': projects,
      'ratings': ratings,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'status': status,
      'joinRequests': joinRequests,
      'clientTasks': clientTasks,
      'foundedAt': foundedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
      'aboutUs': aboutUs,
    };
  }
}

class EditTeamProfileResponseModel {
  final String message;
  final TeamData data;

  EditTeamProfileResponseModel({
    required this.message,
    required this.data,
  });

  factory EditTeamProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return EditTeamProfileResponseModel(
      message: json['message'] ?? '',
      data: TeamData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

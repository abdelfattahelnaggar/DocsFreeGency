class InterestModel {
  final String id;
  final String name;
  final String status;

  InterestModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) => InterestModel(
        id: json['_id'] as String,
        name: json['name'] as String,
        status: json['status'] as String,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'status': status,
      };
}

class ContactInfoModel {
  final String? email;
  final String? phone;

  ContactInfoModel({this.email, this.phone});

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
    };
  }
}

class SocialMediaLinksModel {
  final String? linkedin;
  final String? facebook;
  final String? github;
  final String? website;

  SocialMediaLinksModel(
      {this.linkedin, this.facebook, this.github, this.website});

  factory SocialMediaLinksModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaLinksModel(
      linkedin: json['linkedin'],
      facebook: json['facebook'],
      github: json['github'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'linkedin': linkedin,
      'facebook': facebook,
      'github': github,
      'website': website,
    };
  }
}

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? bio;
  final ContactInfoModel? contactInfo;
  final SocialMediaLinksModel? socialMediaLinks;
  final String? role;
  final List<String> teams;
  final List<String> skills;
  final List<InterestModel> interests;
  final String? image;
  final int averageRating;
  final int ratingCount;
  final bool isVerified;
  final String? fcmToken;
  // final DateTime? passwordChangedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.contactInfo,
    this.socialMediaLinks,
    required this.role,
    required this.teams,
    required this.skills,
    required this.interests,
    required this.image,
    required this.averageRating,
    required this.ratingCount,
    required this.isVerified,
    this.fcmToken,
    // this.passwordChangedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['_id'] as String?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        bio: json['bio'] as String?,
        contactInfo: json['contactInfo'] == null
            ? null
            : ContactInfoModel.fromJson(
                json['contactInfo'] as Map<String, dynamic>),
        socialMediaLinks: json['socialMediaLinks'] == null
            ? null
            : SocialMediaLinksModel.fromJson(
                json['socialMediaLinks'] as Map<String, dynamic>),
        role: json['role'] as String?,
        image: json['profileImage'] as String?,
        teams: json['teams'] == null
            ? []
            : List<String>.from(json['teams'] as List),
        skills: json['skills'] == null
            ? []
            : List<String>.from(json['skills'] as List),
        interests: json['interests'] == null
            ? []
            : List<InterestModel>.from(
                (json['interests'] as List).map(
                    (x) => InterestModel.fromJson(x as Map<String, dynamic>)),
              ),
        averageRating: json['averageRating'] as int? ?? 0,
        ratingCount: json['ratingCount'] as int? ?? 0,
        isVerified: json['isVerified'] as bool? ?? false,
        fcmToken: json['fcmToken'] as String?,
        // passwordChangedAt: json['passwordChangedAt'] == null
        //     ? null
        //     : DateTime.parse(json['passwordChangedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'bio': bio,
        'contactInfo': contactInfo?.toJson(),
        'socialMediaLinks': socialMediaLinks?.toJson(),
        'role': role,
        'profileImage': image,
        'teams': teams,
        'skills': skills,
        'interests': interests.map((x) => x.toJson()).toList(),
        'averageRating': averageRating,
        'ratingCount': ratingCount,
        'isVerified': isVerified,
        'fcmToken': fcmToken,
        // 'passwordChangedAt': passwordChangedAt?.toIso8601String(),
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    ContactInfoModel? contactInfo,
    SocialMediaLinksModel? socialMediaLinks,
    String? role,
    List<String>? teams,
    List<String>? skills,
    List<InterestModel>? interests,
    String? image,
    int? averageRating,
    int? ratingCount,
    bool? isVerified,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      contactInfo: contactInfo ?? this.contactInfo,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      role: role ?? this.role,
      teams: teams ?? this.teams,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      image: image ?? this.image,
      averageRating: averageRating ?? this.averageRating,
      ratingCount: ratingCount ?? this.ratingCount,
      isVerified: isVerified ?? this.isVerified,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}

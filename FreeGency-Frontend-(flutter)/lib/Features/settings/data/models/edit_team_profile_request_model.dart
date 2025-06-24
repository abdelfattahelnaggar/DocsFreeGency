class ContactInfo {
  final String email;
  final String phone;

  ContactInfo({
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
    };
  }

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class SocialMediaLinks {
  final String? linkedin;
  final String? facebook;
  final String? github;
  final String? website;

  SocialMediaLinks({
    this.linkedin,
    this.facebook,
    this.github,
    this.website,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (linkedin != null) data['linkedin'] = linkedin;
    if (facebook != null) data['facebook'] = facebook;
    if (github != null) data['github'] = github;
    if (website != null) data['website'] = website;
    return data;
  }

  factory SocialMediaLinks.fromJson(Map<String, dynamic> json) {
    return SocialMediaLinks(
      linkedin: json['linkedin'],
      facebook: json['facebook'],
      github: json['github'],
      website: json['website'],
    );
  }
}

class EditTeamProfileRequestModel {
  final String name;
  final String aboutUs;
  final ContactInfo contactInfo;
  final SocialMediaLinks socialMediaLinks;
  final List<String> skills;

  EditTeamProfileRequestModel({
    required this.name,
    required this.aboutUs,
    required this.contactInfo,
    required this.socialMediaLinks,
    required this.skills,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'aboutUs': aboutUs,
      'contactInfo': contactInfo.toJson(),
      'socialMediaLinks': socialMediaLinks.toJson(),
      'skills': skills,
    };
  }

  factory EditTeamProfileRequestModel.fromJson(Map<String, dynamic> json) {
    return EditTeamProfileRequestModel(
      name: json['name'] ?? '',
      aboutUs: json['aboutUs'] ?? '',
      contactInfo: ContactInfo.fromJson(json['contactInfo'] ?? {}),
      socialMediaLinks:
          SocialMediaLinks.fromJson(json['socialMediaLinks'] ?? {}),
      skills: List<String>.from(json['skills'] ?? []),
    );
  }
}

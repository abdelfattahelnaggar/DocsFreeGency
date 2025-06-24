import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/user_model.dart';

class UpdateUserProfileRequestModel {
  final String? name;
  final String? bio;
  final ContactInfoModel? contactInfo;
  final SocialMediaLinksModel? socialMediaLinks;
  final List<String>? interests;
  final List<String>? skills;

  UpdateUserProfileRequestModel({
    this.name,
    this.bio,
    this.contactInfo,
    this.socialMediaLinks,
    this.interests,
    this.skills,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) {
      data['name'] = name;
    }
    if (bio != null) {
      data['bio'] = bio;
    }
    if (contactInfo != null) {
      data['contactInfo'] = contactInfo!.toJson();
    }
    if (socialMediaLinks != null) {
      data['socialMediaLinks'] = socialMediaLinks!.toJson();
    }
    if (interests != null) {
      data['interests'] = interests;
    }
    if (skills != null) {
      data['skills'] = skills;
    }
    return data;
  }
}

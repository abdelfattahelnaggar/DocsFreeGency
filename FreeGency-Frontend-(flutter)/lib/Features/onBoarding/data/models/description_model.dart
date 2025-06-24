import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DescriptionModel {
  final String title;
  final String subTitle;

  DescriptionModel({required this.title, required this.subTitle});

  factory DescriptionModel.fromJson(Map json) {
    return DescriptionModel(
      title: json['title'],
      subTitle: json['subTitle'],
    );
  }

  // Get localized onboarding texts
  static List<DescriptionModel> getLocalizedTexts(BuildContext context) {
    return [
      DescriptionModel(
        title: context.tr('onboarding_title_1'),
        subTitle: context.tr('onboarding_subtitle_1'),
      ),
      DescriptionModel(
        title: context.tr('onboarding_title_2'),
        subTitle: context.tr('onboarding_subtitle_2'),
      ),
      DescriptionModel(
        title: context.tr('onboarding_title_3'),
        subTitle: context.tr('onboarding_subtitle_3'),
      ),
      DescriptionModel(
        title: context.tr('onboarding_title_4'),
        subTitle: context.tr('onboarding_subtitle_4'),
      ),
    ];
  }

  // Keep the static list for backward compatibility
  static final List<Map<String, dynamic>> onBoardingTextsList = [
    {
      'title': 'Welcome to Freegency',
      'subTitle':
          'Connecting clients with agencies and teams, Freegency is your all-in-one platform for managing professional collaborations and finding freelance opportunities.',
    },
    {
      'title': 'Seamless Collaboration',
      'subTitle':
          'Simplify communication and project execution with integrated chat, video calls, and task management tools designed for teams and clients.',
    },
    {
      'title': 'Discover Opportunities',
      'subTitle':
          'Whether you\'re an agency, team member, or job seeker, Freegency provides a space to showcase your work and find the right fit for your next project.',
    },
    {
      'title': 'Trusted Transactions',
      'subTitle':
          'With secure payment options and transparent reviews, Freegency ensures a fair, reliable working environment for all.',
    },
  ];
}

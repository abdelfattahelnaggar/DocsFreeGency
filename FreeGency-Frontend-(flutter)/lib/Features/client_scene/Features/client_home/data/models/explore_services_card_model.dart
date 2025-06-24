import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExploreServicesCardModel {
  final String title;
  final String image;
  final Color color;

  ExploreServicesCardModel({
    required this.title,
    required this.image,
    required this.color,
  });

  factory ExploreServicesCardModel.fromJson(Map<String, dynamic> json) {
    return ExploreServicesCardModel(
      title: json['title'],
      image: json['image'],
      color: json['color'],
    );
  }

  // Method to get localized data from context
  static List<ExploreServicesCardModel> getLocalizedCards(
      BuildContext context) {
    return [
      ExploreServicesCardModel(
        title: context.tr('creative_visual'),
        image: 'assets/images/image 6.png',
        color: const Color(0xffF3F3F3),
      ),
      ExploreServicesCardModel(
        title: context.tr('advertising_marketing'),
        image: 'assets/images/image 9.png',
        color: const Color(0xff3C9CF5),
      ),
      ExploreServicesCardModel(
        title: context.tr('development_product'),
        image: 'assets/images/image 10.png',
        color: const Color(0xff53FD84),
      ),
      ExploreServicesCardModel(
        title: context.tr('it_services'),
        image: 'assets/images/image 11.png',
        color: const Color(0xffEACC65),
      ),
    ];
  }

  // Keep the static list for backward compatibility
  static List<ExploreServicesCardModel> exploreServicesCardList = [
    ExploreServicesCardModel(
      title: 'Creative & Visual',
      image: 'assets/images/image 6.png',
      color: const Color(0xffF3F3F3),
    ),
    ExploreServicesCardModel(
      title: 'Advertising & Marketing',
      image: 'assets/images/image 9.png',
      color: const Color(0xff3C9CF5),
    ),
    ExploreServicesCardModel(
      title: 'Development & Product',
      image: 'assets/images/image 10.png',
      color: const Color(0xff53FD84),
    ),
    ExploreServicesCardModel(
      title: 'IT Services',
      image: 'assets/images/image 11.png',
      color: const Color(0xffEACC65),
    ),
  ];
}

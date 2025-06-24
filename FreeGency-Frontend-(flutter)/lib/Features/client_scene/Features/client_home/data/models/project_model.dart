import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';

class CategoryInfo {
  final String? id;
  final String? name;

  CategoryInfo({
    required this.id,
    required this.name,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    try {
      return CategoryInfo(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
      );
    } catch (e) {
      // Fallback to empty values if unable to parse
      return CategoryInfo(id: '', name: '');
    }
  }
}

class ServiceInfo {
  final String? id;
  final String? name;

  ServiceInfo({
    required this.id,
    required this.name,
  });

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    try {
      return ServiceInfo(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
      );
    } catch (e) {
      // Fallback to empty values if unable to parse
      return ServiceInfo(id: '', name: '');
    }
  }
}

class RatedByUser {
  final String? id;
  final String? name;
  final String? profileImage;

  RatedByUser({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory RatedByUser.fromJson(Map<String, dynamic> json) {
    try {
      return RatedByUser(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        profileImage: json['profileImage'] ?? '',
      );
    } catch (e) {
      // Fallback to empty values if unable to parse
      return RatedByUser(id: '', name: '', profileImage: '');
    }
  }
}

class Rating {
  final String? id;
  final int? rating;
  final String? review;
  final RatedByUser? ratedBy;
  final DateTime? createdAt;

  Rating({
    required this.id,
    required this.rating,
    required this.review,
    required this.ratedBy,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    try {
      return Rating(
        id: json['_id'] ?? '',
        rating: json['rating'] ?? 0,
        review: json['review'] ?? '',
        ratedBy: json['ratedBy'] != null
            ? RatedByUser.fromJson(json['ratedBy'])
            : RatedByUser(id: '', name: ''),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
      );
    } catch (e) {
      // Fallback to empty values if unable to parse
      return Rating(
        id: '',
        rating: 0,
        review: '',
        ratedBy: RatedByUser(id: '', name: ''),
        createdAt: null,
      );
    }
  }
}

class ProjectModel {
  final String? id;
  final String? title;
  final String? description;
  final String? budget;
  final List<String>? images;
  final String? projectUrl;
  final List<String>? technologies;
  final DateTime? completionDate;
  final TeamsModel? team;
  final CategoryInfo? category;
  final ServiceInfo? service;
  final String? visibility;
  // final List<String>? ratings;
  final int? averageRating;
  final int? ratingCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? imageCover;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.images,
    required this.projectUrl,
    required this.technologies,
    required this.completionDate,
    required this.team,
    required this.category,
    required this.service,
    required this.visibility,
    // required this.ratings,
    required this.averageRating,
    required this.ratingCount,
    required this.createdAt,
    required this.updatedAt,
    required this.imageCover,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // Handle category which could be a String ID or a Map
    CategoryInfo? categoryInfo;
    if (json['category'] != null) {
      if (json['category'] is Map) {
        categoryInfo =
            CategoryInfo.fromJson(json['category'] as Map<String, dynamic>);
      } else if (json['category'] is String) {
        categoryInfo = CategoryInfo(id: json['category'], name: '');
      }
    }

    // Handle service which could be a String ID or a Map
    ServiceInfo? serviceInfo;
    if (json['service'] != null) {
      if (json['service'] is Map) {
        serviceInfo =
            ServiceInfo.fromJson(json['service'] as Map<String, dynamic>);
      } else if (json['service'] is String) {
        serviceInfo = ServiceInfo(id: json['service'], name: '');
      }
    }

    // Handle imageCover which could be a String or a Map or null
    String? imageUrl;
    if (json['imageCover'] == null) {
      imageUrl = null;
    } else if (json['imageCover'] is String) {
      imageUrl = json['imageCover'];
    } else if (json['imageCover'] is Map) {
      try {
        final Map<String, dynamic> imageCoverMap =
            Map<String, dynamic>.from(json['imageCover']);
        imageUrl = imageCoverMap['url'];
      } catch (e) {
        imageUrl = null;
      }
    }

    return ProjectModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      budget: json['budget'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      projectUrl: json['projectUrl'] ?? '',
      technologies: List<String>.from(json['technologies'] ?? []),
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'])
          : null,
      team: json['team'] != null ? TeamsModel.fromJson(json['team']) : null,
      category: categoryInfo,
      service: serviceInfo,
      visibility: json['visibility'],
      // ratings:
      //     json['ratings'] != null ? List<String>.from(json['ratings']) : [],
      averageRating: (json['ratingCount'] ?? 0),
      ratingCount: json['ratingCount'] ?? 0,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      imageCover: imageUrl,
    );
  }
}

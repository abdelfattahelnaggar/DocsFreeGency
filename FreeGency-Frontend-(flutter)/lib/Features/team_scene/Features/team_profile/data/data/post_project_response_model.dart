import 'dart:developer';

class PostProjectResponseModel {
  final String? status;
  final ProjectResponseData? data;
  final List<ProjectError>? errors;

  PostProjectResponseModel({
    this.status,
    this.data,
    this.errors,
  });

  factory PostProjectResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return PostProjectResponseModel(
        status: json['status'] as String?,
        data: json['data'] != null
            ? ProjectResponseData.fromJson(json['data'])
            : null,
        errors: json['errors'] != null
            ? (json['errors'] as List)
                .map((error) => ProjectError.fromJson(error))
                .toList()
            : null,
      );
    } catch (e) {
      log('Error parsing PostProjectResponseModel: $e');
      log('JSON data: $json');
      rethrow;
    }
  }

  bool get isSuccess => status == 'success';
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  String get errorMessage {
    if (hasErrors) {
      return errors!.map((error) => error.msg).join(', ');
    }
    return 'Something went wrong. Please try again.';
  }
}

class ProjectResponseData {
  final ProjectData? project;

  ProjectResponseData({this.project});

  factory ProjectResponseData.fromJson(Map<String, dynamic> json) {
    try {
      return ProjectResponseData(
        project: json['project'] != null
            ? ProjectData.fromJson(json['project'])
            : null,
      );
    } catch (e) {
      log('Error parsing ProjectResponseData: $e');
      log('JSON data: $json');
      rethrow;
    }
  }
}

class ProjectData {
  final String? id;
  final String? title;
  final String? description;
  final String? budget;
  final String? imageCover;
  final List<dynamic>? images;
  final String? projectUrl;
  final List<String>? technologies;
  final DateTime? completionDate;
  final String? team;
  final String? category;
  final String? service;
  final String? visibility;
  final List<dynamic>? ratings;
  final double? averageRating;
  final int? ratingCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  ProjectData({
    this.id,
    this.title,
    this.description,
    this.budget,
    this.imageCover,
    this.images,
    this.projectUrl,
    this.technologies,
    this.completionDate,
    this.team,
    this.category,
    this.service,
    this.visibility,
    this.ratings,
    this.averageRating,
    this.ratingCount,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) {
    try {
      return ProjectData(
        id: json['_id'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        budget: json['budget'] as String?,
        imageCover: json['imageCover'] as String?,
        images:
            json['images'] != null ? List<dynamic>.from(json['images']) : null,
        projectUrl: json['projectUrl'] as String?,
        technologies: json['technologies'] != null
            ? List<String>.from(json['technologies'])
            : null,
        completionDate: json['completionDate'] != null
            ? DateTime.parse(json['completionDate'] as String)
            : null,
        team: json['team'] as String?,
        category: json['category'] as String?,
        service: json['service'] as String?,
        visibility: json['visibility'] as String?,
        ratings: json['ratings'] != null
            ? List<dynamic>.from(json['ratings'])
            : null,
        averageRating: json['averageRating'] != null
            ? (json['averageRating'] as num).toDouble()
            : null,
        ratingCount: json['ratingCount'] as int?,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        v: json['__v'] as int?,
      );
    } catch (e) {
      log('Error parsing ProjectData: $e');
      log('JSON data: $json');
      rethrow;
    }
  }
}

class ProjectError {
  final String? type;
  final String? value;
  final String? msg;
  final String? path;
  final String? location;

  ProjectError({
    this.type,
    this.value,
    this.msg,
    this.path,
    this.location,
  });

  factory ProjectError.fromJson(Map<String, dynamic> json) {
    try {
      return ProjectError(
        type: json['type'] as String?,
        value: json['value'] as String?,
        msg: json['msg'] as String?,
        path: json['path'] as String?,
        location: json['location'] as String?,
      );
    } catch (e) {
      log('Error parsing ProjectError: $e');
      log('JSON data: $json');
      rethrow;
    }
  }
}

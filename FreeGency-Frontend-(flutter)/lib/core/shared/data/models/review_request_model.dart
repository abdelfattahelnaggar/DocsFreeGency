class ReviewRequestModel {
  final String targetId;
  final String review;
  final int rating;
  final String targetKey;

  ReviewRequestModel(
      {required this.targetId,
      required this.review,
      required this.rating,
      required this.targetKey});

  Map<String, dynamic> toJson() {
    return {
      targetKey: targetId,
      'review': review,
      'rating': rating,
    };
  }
}

class ReviewResponseModel {
  final String id;
  final int rating;
  final String review;
  final RatedByUser ratedBy;
  final String ratedProject;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewResponseModel({
    required this.id,
    required this.rating,
    required this.review,
    required this.ratedBy,
    required this.ratedProject,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
      id: json['_id'] ?? '',
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      ratedBy: RatedByUser.fromJson(json['ratedBy'] ?? {}),
      ratedProject: json['ratedProject'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class RatedByUser {
  final String id;
  final String name;
  final String? profileImage;

  RatedByUser({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory RatedByUser.fromJson(Map<String, dynamic> json) {
    return RatedByUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }
}

class GetReviewsResponseModel {
  final String status;
  final int results;
  final List<ReviewResponseModel> data;

  GetReviewsResponseModel({
    required this.status,
    required this.results,
    required this.data,
  });

  factory GetReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetReviewsResponseModel(
      status: json['status'] ?? '',
      results: json['results'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  ReviewResponseModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

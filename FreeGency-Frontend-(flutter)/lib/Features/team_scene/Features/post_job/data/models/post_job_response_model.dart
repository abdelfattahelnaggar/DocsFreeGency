class PostJobResponseModel {
  final String status;
  final String message;
  final PostJobData? data;

  PostJobResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory PostJobResponseModel.fromJson(Map<String, dynamic> json) {
    return PostJobResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? PostJobData.fromJson(json['data']) : null,
    );
  }
}

class PostJobData {
  final String id;
  final String title;
  final String description;
  final List<String> requiredSkills;
  final String createdAt;

  PostJobData({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredSkills,
    required this.createdAt,
  });

  factory PostJobData.fromJson(Map<String, dynamic> json) {
    return PostJobData(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requiredSkills: List<String>.from(json['required_skills'] ?? []),
      createdAt: json['created_at'] ?? '',
    );
  }
}

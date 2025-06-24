class PostJobRequestModel {
  final String title;
  final String description;
  final List<String> requiredSkills;

  PostJobRequestModel({
    required this.title,
    required this.description,
    required this.requiredSkills,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'required_skills': requiredSkills,
    };
  }

  factory PostJobRequestModel.fromJson(Map<String, dynamic> json) {
    return PostJobRequestModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requiredSkills: List<String>.from(json['required_skills'] ?? []),
    );
  }
}

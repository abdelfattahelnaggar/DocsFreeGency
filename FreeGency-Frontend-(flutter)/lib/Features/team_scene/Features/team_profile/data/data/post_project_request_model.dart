import 'dart:io';

class PostProjectRequestModel {
  final String title;
  final String description;
  final double budget;
  final String projectUrl;
  final List<String> technologies;
  final DateTime completionDate;
  final String service;
  final List<File>? images;

  PostProjectRequestModel({
    required this.title,
    required this.description,
    required this.budget,
    required this.projectUrl,
    required this.technologies,
    required this.completionDate,
    required this.service,
    this.images,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'budget': budget,
        'projectUrl': projectUrl,
        'technologies': technologies,
        'completionDate': completionDate.toIso8601String(),
        'service': service,
        // Don't include the images in the JSON as they will be handled separately in the FormData
      };

  // Helper method to check if images are provided
  bool get hasImages => images != null && images!.isNotEmpty;

  // Helper method to get the number of images
  int get imageCount => images?.length ?? 0;
}

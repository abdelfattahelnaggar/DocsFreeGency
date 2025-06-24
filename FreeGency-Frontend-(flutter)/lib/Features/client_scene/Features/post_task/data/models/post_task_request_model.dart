import 'dart:io';

class PostTaskRequestModel {
  final String title;
  final String description;
  final double budget;
  final List<String> requiredSkills;
  final String category;
  final String service;
  final DateTime deadline;
  final bool isFixedPrice;
  final File? relatedFile;

  PostTaskRequestModel({
    required this.title,
    required this.description,
    required this.budget,
    required this.requiredSkills,
    required this.category,
    required this.service,
    required this.deadline,
    required this.isFixedPrice,
    required this.relatedFile,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'budget': budget,
        'requiredSkills': requiredSkills,
        'category': category,
        'service': service,
        'deadline': deadline.toIso8601String(),
        'isFixedPrice': isFixedPrice,
        // Don't include the file in the JSON as it will be handled separately in the FormData
      };
}

class JobModel {
  final String id;
  final String jobTitle;
  final String timePosted;
  final String logoUrl;
  final String? description;
  final String? createdByTeam;
  final List<String>? requiredSkills;
  final DateTime createdAt;

  JobModel({
    required this.id,
    required this.jobTitle,
    required this.timePosted,
    required this.logoUrl,
    this.description,
    this.requiredSkills,
    required this.createdAt,
    this.createdByTeam,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id']?.toString() ?? '',
      jobTitle: json['title'] ?? '',
      createdByTeam: json['createdByTeam'] != null
          ? json['createdByTeam']['name'] ?? 'Unknown Company'
          : 'Unknown Company',
      timePosted: json['createdAt'] ?? '',
      logoUrl: json['imageCover'] ?? '',
      description: json['description'],
      requiredSkills: json['requiredSkills'] != null
          ? (json['requiredSkills'] as List).map((e) => e.toString()).toList()
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_title': jobTitle,
      'description': description,
      'requiredSkills': requiredSkills,
    };
  }

  String getFormattedTime() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

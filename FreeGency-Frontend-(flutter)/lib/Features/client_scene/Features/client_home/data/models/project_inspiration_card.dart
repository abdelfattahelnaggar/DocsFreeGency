class ProjectInspirationCardModel {
  final String title;
  final String demoLink;
  final int rate;
  final int reviewCount;
  final String description;
  final String teamName;
  final DateTime postDate;
  final double budget;
  final String projectType;
  final List<String> skills;
  final List<String> projectImages;
  final Map<String, List> reviews;

  ProjectInspirationCardModel({
    required this.title,
    required this.demoLink,
    required this.rate,
    required this.reviewCount,
    required this.description,
    required this.teamName,
    required this.postDate,
    required this.budget,
    required this.projectType,
    required this.skills,
    required this.projectImages,
    required this.reviews,
  });
}

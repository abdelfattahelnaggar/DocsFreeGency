class AssignTaskToMemberModel {
  final String? title;
  final String? description;
  final String? assignedTo;
  final DateTime? deadline;

  AssignTaskToMemberModel({
    this.title,
    this.description,
    this.assignedTo,
    this.deadline,
  });

  factory AssignTaskToMemberModel.fromJson(Map<String, dynamic> json) => AssignTaskToMemberModel(
        title: json['title'],
        description: json['description'],
        assignedTo: json['assignedTo'],
        deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'assignedTo': assignedTo,
        'deadline': deadline?.toIso8601String(),
      };
}

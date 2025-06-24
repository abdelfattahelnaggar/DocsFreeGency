class SubTaskModel {
  final SubTaskDetails subtaskDetails;
  final AssignedTo assignedTo;
  final List<Comment> comments;

  SubTaskModel({
    required this.subtaskDetails,
    required this.assignedTo,
    required this.comments,
  });

  factory SubTaskModel.fromJson(Map<String, dynamic> json) {
    return SubTaskModel(
      subtaskDetails: SubTaskDetails.fromJson(json['subtaskDetails']),
      assignedTo: AssignedTo.fromJson(json['assignedTo']),
      comments: (json['comments'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtaskDetails': subtaskDetails.toJson(),
      'assignedTo': assignedTo.toJson(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}

class SubTaskDetails {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime deadline;

  SubTaskDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
  });

  factory SubTaskDetails.fromJson(Map<String, dynamic> json) {
    return SubTaskDetails(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      deadline: DateTime.parse(json['deadline']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'deadline': deadline.toIso8601String(),
    };
  }
}

class AssignedTo {
  final String id;
  final String name;
  final String profileImage;

  AssignedTo({
    required this.id,
    required this.name,
    required this.profileImage,
  });

  factory AssignedTo.fromJson(Map<String, dynamic> json) {
    return AssignedTo(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
    };
  }
}

class Comment {
  final String id;
  final String text;
  final AssignedTo user;

  Comment({
    required this.id,
    required this.text,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      user: AssignedTo.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'user': user.toJson(),
    };
  }
}

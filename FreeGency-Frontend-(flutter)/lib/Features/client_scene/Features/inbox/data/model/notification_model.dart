import 'package:intl/intl.dart';

class NotificationModel {
  final String? id;
  final String? userId;
  final String title;
  final String body;
  final String imageUrl;
  final String type;
  final String? actionUrl;
  final bool isRead;
  final DateTime sentAt;
  // final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? data;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.type,
    this.actionUrl,
    required this.isRead,
    required this.sentAt,
    // required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['_id'] as String,
        userId: json['userId'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        imageUrl: json['imageUrl'] as String,
        type: json['type'] as String,
        actionUrl: json['actionUrl'] as String?,
        isRead: json['isRead'] as bool? ?? false,
        sentAt: DateTime.parse(json['sentAt']).toLocal(),
        // expiresAt: DateTime.parse(json['expiresAt']).toLocal(),
        createdAt: DateTime.parse(json['createdAt']).toLocal(),
        updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
        data: json['data']);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'type': type,
      'actionUrl': actionUrl,
      'isRead': isRead,
      'sentAt': sentAt.toIso8601String(),
      // 'expiresAt': expiresAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'data': data,
    };
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(sentAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(sentAt);
  }
}

// class NotificationData {
//   final String? taskId;
//   final String? category;
//   final int? budget;
//   final String? userId;

//   NotificationData({
//     required this.taskId,
//     required this.category,
//     required this.budget,
//     required this.userId,
//   });

//   factory NotificationData.fromJson(Map<String, dynamic> json) {
//     return NotificationData(
//       taskId: json['taskId'] ,
//       category: json['category'],
//       budget: json['budget'],
//       userId: json['userId'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'taskId': taskId,
//       'category': category,
//       'budget': budget,
//       'userId': userId,
//     };
//   }
// }

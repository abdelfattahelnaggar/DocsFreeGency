import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_request_model.dart';

class AssignedMember {
  final String? id;
  final String? profileImage;

  AssignedMember({
    this.id,
    this.profileImage,
  });

  factory AssignedMember.fromJson(Map<String, dynamic> json) => AssignedMember(
        id: json['_id'],
        profileImage: json['profileImage'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'profileImage': profileImage,
      };
}

class TaskModel {
  final String? id;
  final String? title;
  final String? description;
  final bool? isFixedPrice;
  final int? budget;
  final String? categoryId;
  final String? category;
  final String? serviceId;
  final String? service;
  final List<String>? requiredSkills;
  final DateTime? deadline;
  final String? status;
  final String? clientName;
  final String? clientId;
  final String? clientProfileImage;
  final List<TeamRequestModel>? teamRequests;
  final String? requirementFileName;
  final String? requirementFileUrl;
  final List<dynamic>? taskFiles;
  final List<dynamic>? taskHistory;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AssignedMember>? assignedMembers;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.isFixedPrice,
    this.budget,
    this.categoryId,
    this.category,
    this.serviceId,
    this.service,
    this.requiredSkills,
    this.deadline,
    this.status,
    this.clientName,
    this.clientId,
    this.clientProfileImage,
    this.teamRequests,
    this.requirementFileName,
    this.requirementFileUrl,
    this.taskFiles,
    this.taskHistory,
    this.createdAt,
    this.updatedAt,
    this.assignedMembers,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        isFixedPrice: json['isFixedPrice'],
        budget: json['budget'],
        categoryId: json['category']?['_id'],
        category: json['category']?['name'],
        serviceId: json['service']?['_id'],
        service: json['service']?['name'],
        requiredSkills: json['requiredSkills'] != null
            ? List<String>.from(json['requiredSkills'])
            : null,
        deadline:
            json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
        status: json['status'],
        clientName: json['client']?['name'],
        clientId: json['client']?['_id'],
        clientProfileImage: json['client']?['profileImage'],
        teamRequests: json['teamRequests'] != null
            ? List<TeamRequestModel>.from(
                json['teamRequests'].map((x) => TeamRequestModel.fromJson(x)))
            : null,
        requirementFileName: json['fileName'],
        requirementFileUrl: json['fileUrl'],
        taskFiles: json['taskFiles'],
        taskHistory: json['taskHistory'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt']).toLocal()
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt']).toLocal()
            : null,
        assignedMembers: json['assignedMembers'] != null
            ? List<AssignedMember>.from(
                json['assignedMembers'].map((x) => AssignedMember.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'description': description,
        'isFixedPrice': isFixedPrice,
        'budget': budget,
        'category': {
          '_id': categoryId,
          'name': category,
        },
        'service': {
          '_id': serviceId,
          'name': service,
        },
        'requiredSkills': requiredSkills,
        'deadline': deadline?.toIso8601String(),
        'status': status,
        'client': {
          '_id': clientId,
          'name': clientName,
          'profileImage': clientProfileImage,
        },
        'teamRequests': teamRequests,
        'fileName': requirementFileName,
        'fileUrl': requirementFileUrl,
        'taskFiles': taskFiles,
        'taskHistory': taskHistory,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  String get timeAgo {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  String getLocalizedTimeAgo(BuildContext context) {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return context.tr('years_ago', args: ['$years']);
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return context.tr('months_ago', args: ['$months']);
    } else if (difference.inDays > 0) {
      return context.tr('days_ago', args: ['${difference.inDays}']);
    } else if (difference.inHours > 0) {
      return context.tr('hours_ago', args: ['${difference.inHours}']);
    } else if (difference.inMinutes > 0) {
      return context.tr('minutes_ago', args: ['${difference.inMinutes}']);
    } else {
      return context.tr('just_now');
    }
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy - hh:mm a')
        .format(createdAt ?? DateTime.now());
  }

  // Get localized price type
  String getLocalizedPriceType(BuildContext context) {
    return isFixedPrice == true
        ? context.tr('fixed_price')
        : context.tr('changeable_price');
  }


  String get deadlineTimeAgo {
    if (deadline == null) return '';
    final now = DateTime.now();
    final difference = deadline!.difference(now);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years years left';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months months left';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours left';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes left';
    } else {
      return 'Deadline passed';
    }
  }

  String getLocalizedDeadlineTimeAgo(BuildContext context) {
    if (deadline == null) return '';
    final now = DateTime.now();
    final difference = deadline!.difference(now);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return context.tr('years_left', args: ['$years']);
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return context.tr('months_left', args: ['$months']);
    } else if (difference.inDays > 0) {
      return context.tr('days_left', args: ['${difference.inDays}']);
    } else if (difference.inHours > 0) {
      return context.tr('hours_left', args: ['${difference.inHours}']);
    } else if (difference.inMinutes > 0) {
      return context.tr('minutes_left', args: ['${difference.inMinutes}']);
    } else {
      return context.tr('deadline_passed');
    }
  }
}

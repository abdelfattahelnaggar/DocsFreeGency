import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';

class TeamsModel {
  final String? id;
  final String? teamLeader;
  final String? name;
  final String? teamCode;
  final String? category;
  final List<TeamMember>? members;
  final List<ProjectModel>? projects;
  // final List<String>? ratings;
  final int? averageRating;
  final int? ratingCount;
  final String? status;
  final List<String>? joinRequests;
  final List<String>? clientTasks;
  final DateTime? foundedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  String? logo;
  final String? about;
  final List<String>? skills;
  final Map<String, String>? contactInfo;
  final List<Map<String, dynamic>>? socialMediaLinks;

  TeamsModel({
    this.id,
    this.teamLeader,
    this.name,
    this.teamCode,
    this.category,
    this.members,
    this.projects,
    // this.ratings,
    this.averageRating,
    this.ratingCount,
    this.status,
    this.joinRequests,
    this.clientTasks,
    this.foundedAt,
    this.createdAt,
    this.updatedAt,
    this.logo,
    this.about,
    this.skills,
    this.contactInfo,
    this.socialMediaLinks,
  }) {
    // Fix logo URL if it contains the error path
    if (logo != null && logo!.contains('/api/v1/teams/my-team/logo')) {
      logo = '';
    }
  }
  String get formattedFoundedDate {
    if (foundedAt == null) return '';
    return DateFormat('dd/MM/yyyy').format(foundedAt!);
  }

  // Get a localized time ago string
  String getLocalizedFoundedTimeAgo(BuildContext context) {
    if (foundedAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(foundedAt!);

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

  String get formattedCreatedDate {
    if (createdAt == null) return '';
    return DateFormat('dd/MM/yyyy').format(createdAt!);
  }

  String getLocalizedCreatedDate(BuildContext context) {
    if (createdAt == null) return '';
    final locale = context.locale.languageCode;
    return DateFormat.yMMMMd(locale).format(createdAt!);
  }

  String get formattedUpdatedDate {
    if (updatedAt == null) return '';
    return DateFormat('dd/MM/yyyy').format(updatedAt!);
  }

  factory TeamsModel.fromJson(Map<String, dynamic> json) {
    try {
      // Handle category which could be a string ID or a Map
      String? categoryValue;
      if (json['category'] != null) {
        if (json['category'] is Map) {
          final categoryMap = json['category'] as Map<String, dynamic>;
          categoryValue =
              categoryMap['_id'] ?? categoryMap['name'] ?? 'no category';
        } else if (json['category'] is String) {
          categoryValue = json['category'];
        } else {
          categoryValue = 'no category';
        }
      } else {
        categoryValue = 'no category';
      }

      // Handle members which could be null or a list
      List<TeamMember> members = [];
      if (json['members'] != null && json['members'] is List) {
        for (var memberJson in json['members']) {
          try {
            members.add(TeamMember.fromJson(memberJson));
          } catch (e) {
            // Skip this member if parsing fails
          }
        }
      }

      // Handle social media links which could be an object or a list
      List<Map<String, dynamic>>? socialMediaLinks;
      if (json['socialMediaLinks'] != null) {
        if (json['socialMediaLinks'] is Map) {
          // Convert object format to list format for internal use
          final socialLinksMap =
              json['socialMediaLinks'] as Map<String, dynamic>;
          socialMediaLinks = [];

          socialLinksMap.forEach((platform, url) {
            socialMediaLinks!.add({
              'id': DateTime.now().millisecondsSinceEpoch.toString() + platform,
              'platform': platform.capitalize(),
              'url': url.toString(),
            });
          });
        } else if (json['socialMediaLinks'] is List) {
          // Already in list format
          socialMediaLinks =
              List<Map<String, dynamic>>.from(json['socialMediaLinks']);
        }
      }

      // Handle logo URL
      String? logoUrl = json['logo'];
      if (logoUrl != null && logoUrl.contains('/api/v1/teams/my-team/logo')) {
        logoUrl = '';
      }

      return TeamsModel(
        id: json['_id'] ?? 'no id',
        teamLeader: json['teamLeader'] ?? 'no team leader',
        name: json['name'] ?? 'no name',
        teamCode: json['teamCode'] ?? 'no team code',
        category: categoryValue,
        members: members,
        projects: json['Projects'] != null
            ? (json['Projects'] as List<dynamic>)
                .map((project) =>
                    ProjectModel.fromJson(project as Map<String, dynamic>))
                .toList()
            : [],
        // ratings: (json['ratings'] as List<dynamic>?)?.cast<String>() ?? [],
        averageRating: json['averageRating'] ?? 0,
        ratingCount: json['ratingCount'] ?? 0,
        status: json['status'],
        joinRequests: (json['joinRequests'] as List<dynamic>?)?.cast<String>(),
        clientTasks: (json['clientTasks'] as List<dynamic>?)?.cast<String>(),
        foundedAt: json['foundedAt'] != null
            ? DateTime.parse(json['foundedAt'])
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        logo: logoUrl,
        about: json['aboutUs'],
        skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
        contactInfo: json['contactInfo'] != null
            ? Map<String, String>.from(json['contactInfo'])
            : null,
        socialMediaLinks: socialMediaLinks,
      );
    } catch (e) {
      // Fallback to default values if parsing fails
      return TeamsModel(
        id: 'error',
        name: 'Error loading team',
        category: 'unknown',
        averageRating: 0,
        ratingCount: 0,
      );
    }
  }

  TeamsModel copyWith({
    String? id,
    String? teamLeader,
    String? name,
    String? teamCode,
    String? category,
    List<TeamMember>? members,
    List<ProjectModel>? projects,
    int? averageRating,
    int? ratingCount,
    String? status,
    List<String>? joinRequests,
    List<String>? clientTasks,
    DateTime? foundedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? logo,
    String? about,
    List<String>? skills,
    Map<String, String>? contactInfo,
    List<Map<String, dynamic>>? socialMediaLinks,
  }) {
    return TeamsModel(
      id: id ?? this.id,
      teamLeader: teamLeader ?? this.teamLeader,
      name: name ?? this.name,
      teamCode: teamCode ?? this.teamCode,
      category: category ?? this.category,
      members: members ?? this.members,
      projects: projects ?? this.projects,
      averageRating: averageRating ?? this.averageRating,
      ratingCount: ratingCount ?? this.ratingCount,
      status: status ?? this.status,
      joinRequests: joinRequests ?? this.joinRequests,
      clientTasks: clientTasks ?? this.clientTasks,
      foundedAt: foundedAt ?? this.foundedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      logo: logo ?? this.logo,
      about: about ?? this.about,
      skills: skills ?? this.skills,
      contactInfo: contactInfo ?? this.contactInfo,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
    );
  }
}

class TeamMember {
  final String? user;
  final String? role;
  final String? job;
  final DateTime? joinedAt;
  final String? id;

  TeamMember({
    this.user,
    this.role,
    this.job,
    this.joinedAt,
    this.id,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    try {
      // Handle user which could be an ID string or a user object
      String? userId;
      if (json['user'] != null) {
        if (json['user'] is Map) {
          final userMap = json['user'] as Map<String, dynamic>;
          userId = userMap['_id'] ?? '';
        } else if (json['user'] is String) {
          userId = json['user'];
        }
      }

      DateTime? parsedJoinedAt;
      if (json['joinedAt'] != null) {
        try {
          parsedJoinedAt = DateTime.parse(json['joinedAt']);
        } catch (e) {
          // Failed to parse date
        }
      }

      return TeamMember(
        user: userId,
        role: json['role'],
        job: json['job'],
        joinedAt: parsedJoinedAt,
        id: json['_id'],
      );
    } catch (e) {
      // Return a fallback member if parsing fails
      return TeamMember(
        user: 'unknown',
        role: 'unknown',
        job: 'unknown',
        id: 'error',
      );
    }
  }
}

// Extension to capitalize first letter of string
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

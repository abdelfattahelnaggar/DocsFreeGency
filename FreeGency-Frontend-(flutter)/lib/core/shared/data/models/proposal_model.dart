import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProposalModel {
  final String? id;
  final String? note;
  final String? teamName;
  final String? teamLogo;
  final String? teamId;
  final int? budget;
  final List<ProposalFile>? proposalFiles;
  final String? similarProjectUrl;
  final String? status;
  final DateTime? appliedAt;

  // Get a non-localized time ago string (for backwards compatibility)
  String get timeAgo {
    if (appliedAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(appliedAt!);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
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

  // Get a localized time ago string
  String getLocalizedTimeAgo(BuildContext context) {
    if (appliedAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(appliedAt!);

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
    if (appliedAt == null) return '';
    return '${appliedAt!.day}/${appliedAt!.month}/${appliedAt!.year}';
  }

  ProposalModel({
    this.id,
    this.note,
    this.teamName,
    this.teamLogo,
    this.teamId,
    this.proposalFiles,
    this.similarProjectUrl,
    this.status,
    this.appliedAt,
    this.budget,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['_id'],
      note: json['note'],
      teamName: json['team']?['name'],
      teamLogo: json['team']?['logo'],
      teamId: json['team']?['_id'],
      proposalFiles: (json['proposal'] as List<dynamic>?)
          ?.map((file) => ProposalFile.fromJson(file))
          .toList(),
      similarProjectUrl: json['similarProjectUrl'],
      status: json['status'],
      appliedAt:
          json['appliedAt'] != null ? DateTime.parse(json['appliedAt']) : null,
      budget: json['budget'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'note': note,
      'team': {
        'name': teamName,
        'logo': teamLogo,
        '_id': teamId,
      },
      'proposal': proposalFiles?.map((file) => file.toJson()).toList(),
      'similarProjectUrl': similarProjectUrl,
      'status': status,
      'appliedAt': appliedAt?.toIso8601String(),
      'budget': budget,
    };
  }
}

class ProposalFile {
  final String? id;
  final String? fileName;
  final String? fileUrl;

  ProposalFile({
    this.id,
    this.fileName,
    this.fileUrl,
  });

  factory ProposalFile.fromJson(Map<String, dynamic> json) {
    return ProposalFile(
      id: json['_id'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fileName': fileName,
      'fileUrl': fileUrl,
    };
  }
}

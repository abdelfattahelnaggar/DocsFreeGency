import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freegency_gp/core/shared/data/models/proposal_model.dart';

class TeamRequestModel {
  final String? id;
  final String? teamId;
  final String? teamName;
  final String? teamLogo;
  final String? note;
  final List<ProposalFile>? proposal;
  final int? budget;
  final String? similarProjectUrl;
  final String? status;
  final DateTime? appliedAt;
  final DateTime? responseAt;
  final String? responseBy;
  final bool? isOpen;
  final String? createdAt;

  TeamRequestModel({
    this.id,
    this.teamId,
    this.teamName,
    this.teamLogo,
    this.note,
    this.proposal,
    this.budget,
    this.similarProjectUrl,
    this.status,
    this.appliedAt,
    this.responseAt,
    this.responseBy,
    this.isOpen,
    this.createdAt,
  });

  factory TeamRequestModel.fromJson(Map<String, dynamic> json) {
    return TeamRequestModel(
      id: json['_id'],
      teamId: json['team'] is Map ? json['team']['_id'] : json['team'],
      teamName: json['team'] is Map ? json['team']['name'] : json['teamName'],
      teamLogo: json['teamLogo'],
      note: json['note'],
      proposal: json['proposal'] != null
          ? List<ProposalFile>.from(
              json['proposal'].map((x) => ProposalFile.fromJson(x)))
          : null,
      budget: json['budget'],
      similarProjectUrl: json['similarProjectUrl'],
      status: json['status'],
      appliedAt:
          json['appliedAt'] != null ? DateTime.parse(json['appliedAt']) : null,
      responseAt: json['responseAt'] != null
          ? DateTime.parse(json['responseAt'])
          : null,
      responseBy: json['responseBy'],
      isOpen: json['isOpen'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'team': teamId,
        'note': note,
        'proposal': proposal?.map((x) => x.toJson()).toList(),
        'budget': budget,
        'similarProjectUrl': similarProjectUrl,
        'status': status,
        'appliedAt': appliedAt?.toIso8601String(),
        'responseAt': responseAt?.toIso8601String(),
        'responseBy': responseBy,
        'teamName': teamName,
        'teamLogo': teamLogo,
        'isOpen': isOpen,
        'createdAt': createdAt,
      };

  // Get a non-localized time ago string
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
}
import 'dart:developer';

class PostTaskResponseModel {
  final String? status;
  final TaskData? data;
  final String? message;

  PostTaskResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory PostTaskResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return PostTaskResponseModel(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: json['data'] != null ? TaskData.fromJson(json['data']) : null,
      );
    } catch (e) {
      log('Error parsing PostTaskResponseModel: $e');
      log('JSON data: $json');
      rethrow;
    }
  }
}

class TaskData {
  final String? id;
  final String? title;
  final String? description;
  final bool? isFixedPrice;
  final double? budget;
  final String? category;
  final String? service;
  final List<String>? requiredSkills;
  final DateTime? deadline;
  final String? status;
  final String? client;
  final List<dynamic>? teamRequests;
  final List<dynamic>? requirment;
  final List<dynamic>? taskFiles;
  final List<dynamic>? taskHistory;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  TaskData({
    this.id,
    this.title,
    this.description,
    this.isFixedPrice,
    this.budget,
    this.category,
    this.service,
    this.requiredSkills,
    this.deadline,
    this.status,
    this.client,
    this.teamRequests,
    this.requirment,
    this.taskFiles,
    this.taskHistory,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    try {
      return TaskData(
        id: json['_id'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        isFixedPrice: json['isFixedPrice'] as bool?,
        budget:
            json['budget'] != null ? (json['budget'] as num).toDouble() : null,
        category: json['category'] as String?,
        service: json['service'] as String?,
        requiredSkills: json['requiredSkills'] != null
            ? List<String>.from(json['requiredSkills'])
            : null,
        deadline: json['deadline'] != null
            ? DateTime.parse(json['deadline'] as String)
            : null,
        status: json['status'] as String?,
        client: json['client'] as String?,
        teamRequests: json['teamRequests'] != null
            ? List<dynamic>.from(json['teamRequests'])
            : null,
        requirment: json['requirment'] != null
            ? List<dynamic>.from(json['requirment'])
            : null,
        taskFiles: json['taskFiles'] != null
            ? List<dynamic>.from(json['taskFiles'])
            : null,
        taskHistory: json['taskHistory'] != null
            ? List<dynamic>.from(json['taskHistory'])
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        v: json['__v'] as int?,
      );
    } catch (e) {
      log('Error parsing TaskData: $e');
      log('JSON data: $json');
      rethrow;
    }
  }
}

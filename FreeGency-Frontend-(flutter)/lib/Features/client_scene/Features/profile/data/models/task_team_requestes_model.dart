
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_request_model.dart';

class TaskRequestsModel {
  final List<TeamRequestModel> pending;
  final List<TeamRequestModel> accepted;
  final List<TeamRequestModel> rejected;

  TaskRequestsModel({
    required this.pending,
    required this.accepted,
    required this.rejected,
  });

  factory TaskRequestsModel.fromJson(Map<String, dynamic> json) {
    return TaskRequestsModel(
      pending: json['pending'] != null
          ? List<TeamRequestModel>.from(
              json['pending'].map((x) => TeamRequestModel.fromJson(x)))
          : [],
      accepted: json['accepted'] != null
          ? List<TeamRequestModel>.from(
              json['accepted'].map((x) => TeamRequestModel.fromJson(x)))
          : [],
      rejected: json['rejected'] != null
          ? List<TeamRequestModel>.from(
              json['rejected'].map((x) => TeamRequestModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'pending': pending.map((x) => x.toJson()).toList(),
        'accepted': accepted.map((x) => x.toJson()).toList(),
        'rejected': rejected.map((x) => x.toJson()).toList(),
      };
}
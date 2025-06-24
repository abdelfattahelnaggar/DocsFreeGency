import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';

class MyTasksResponseModel {
  final int? postedProjects;
  final int? projectsInProgress; 
  final int? completedProjects;
  final List<TaskModel>? tasks;

  MyTasksResponseModel({
    required this.postedProjects,
    required this.projectsInProgress,
    required this.completedProjects,
    required this.tasks,
  });

  factory MyTasksResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return MyTasksResponseModel(
      postedProjects: data['postedProjects'],
      projectsInProgress: data['projectsInProgress'],
      completedProjects: data['completedProjects'],
      tasks: (data['tasks'] as List)
          .map((task) => TaskModel.fromJson(task))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': {
      'postedProjects': postedProjects,
      'projectsInProgress': projectsInProgress,
      'completedProjects': completedProjects,
      'tasks': tasks == null ? [] : tasks!.map((task) => task.toJson()).toList(),
    }
  };
}

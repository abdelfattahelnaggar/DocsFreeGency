
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_inspiration_view_card.dart';

class GridViewLoaded extends StatelessWidget {
  const GridViewLoaded({
    super.key,
    required this.team,
  });

  final TeamsModel team;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.98,
      ),
      itemCount: team.projects?.length ?? 0,
      itemBuilder: (context, index) {
        final project = team.projects![index];
        return ProjectInspirationViewCard(projectModel: project);
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_comments_and_rate_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_images_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/top_project_details_section.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class ProjectInspirationPageBody extends StatelessWidget {
  const ProjectInspirationPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const TopProjectDetailsSection(),
        24.height,
        const ImagesSection(),
        const ProjectCommentsAndRateSection()
      ],
    );
  }
}

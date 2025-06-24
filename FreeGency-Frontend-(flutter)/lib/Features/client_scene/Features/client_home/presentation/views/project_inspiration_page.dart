import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/client_home_repository/implemented_client_home_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/view_model/project_inspiration/cubit/project_inspiration_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/full_project_inspiration_page_body.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:get/get.dart';

class ProjectInspirationPage extends StatelessWidget {
  const ProjectInspirationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projectModel = Get.arguments as ProjectModel;
    return Scaffold(
      appBar: CustomAppBar(
        isHome: false,
        child: ReusableTextStyleMethods.poppins16BoldMethod(
          context: context,
          text: 'Project Inspiration',
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            ProjectInspirationCubit(ImplementedClientHomeRepo())
              ..getProjectInspirationData(projectModel.id!),
        child: const ProjectInspirationPageBody(),
      ),
    );
  }
}

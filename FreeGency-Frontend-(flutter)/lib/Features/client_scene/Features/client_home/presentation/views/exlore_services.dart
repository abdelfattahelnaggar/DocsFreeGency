import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/view_model/explore_services/cubit/exploring_progects_with_categories_and_services_cubit_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/explore_services_app_bar.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_inspiration_view_card.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_shimmer_card.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/service_list_item.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class ExplortServicesByCategory extends StatefulWidget {
  const ExplortServicesByCategory({super.key});

  @override
  State<ExplortServicesByCategory> createState() =>
      _ExplortServicesByCategoryState();
}

class _ExplortServicesByCategoryState extends State<ExplortServicesByCategory> {
  bool isDropdownOpen = false;
  String selectedText = '';
  String selectedNumber = '';
  // call the arguments
  final category = Get.arguments;

  void _toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  void _onItemSelected(int index) {
    setState(() {
      selectedText = category.services[index].name;
      selectedNumber = category.services[index].id;
      isDropdownOpen = false;
    });

    // Call getProjectByCategoryOrService with the selected service ID
    context
        .read<ExploringProgectsWithCategoriesAndServicesCubit>()
        .getProjectByCategoryOrService(
            'services/${category.services[index].id}');
  }

  @override
  void initState() {
    super.initState();
    // Load projects by category initially
    context
        .read<ExploringProgectsWithCategoriesAndServicesCubit>()
        .getProjectByCategoryOrService('categories/${category.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExploreServicesAppBar(
        isDropdownOpen: isDropdownOpen,
        selectedText: selectedText,
        onTitleTap: _toggleDropdown,
        categoryName: category.name,
      ),
      body: BlocBuilder<ExploringProgectsWithCategoriesAndServicesCubit,
          ExploringProgectsWithCategoriesAndServicesState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand, // Ensure the stack fills the screen
            children: [
              // Main content
              Positioned.fill(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  children: [
                    16.height,
                    if (state
                        is ExploringProgectsWithCategoriesAndServicesCubitSuccess)
                      _buildProjectsGrid(state.projects)
                    else if (state
                        is ExploringProgectsWithCategoriesAndServicesCubitFailure)
                      Center(
                        child: Text(state.errorMessage),
                      )
                    else
                      _buildLoadingShimmer(),
                  ],
                ),
              ),

              // Dropdown overlay
              if (isDropdownOpen)
                Positioned.fill(
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: SafeArea(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 16.h),
                        itemCount: category.services.length,
                        itemBuilder: (context, index) {
                          return ServiceListItem(
                            text: category.services[index].name,
                            image: category.services[index].image,
                            onTap: () => _onItemSelected(index),
                          );
                        },
                        separatorBuilder: (context, index) => 16.height,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProjectsGrid(List<ProjectModel> projects) {
    if (projects.isEmpty) {
      return Center(
        child: ReusableTextStyleMethods.poppins16RegularMethod(context: context, text: 'No projects found'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.98,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) => ProjectInspirationViewCard(
        projectModel: projects[index],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.98,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => const ProjectsShimmer(),
    );
  }
}

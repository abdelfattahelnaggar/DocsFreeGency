import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/view_model/home_tap/cubit/client_home_tap_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/explore_services_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_inspiration_view_card.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/project_shimmer_card.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/top_teams_section_builder.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:get/get.dart';

class HomeTapBody extends StatefulWidget {
  const HomeTapBody({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<HomeTapBody> createState() => _HomeTapBodyState();
}

class _HomeTapBodyState extends State<HomeTapBody> {
  bool _isClient = false;
  bool _isGuest = false;
  bool _shouldShowContent = false;
  bool _isTeamMember = false;
  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    _isClient = await LocalStorage.isClient();
    _isGuest = await LocalStorage.isGuest();
    _isTeamMember = await LocalStorage.isTeamMember();
    _shouldShowContent = _isClient ||
        _isGuest ||
        _isTeamMember; // Show content for both client and guest
    if (mounted) setState(() {});
  }

  Future<void> _onRefresh(BuildContext context) async {
    if (!_shouldShowContent) return;

    try {
      final cubit = context.read<ClientHomeTapCubit>();
      final categoriesCubit = context.read<GetCategoriesAndServicesCubit>();

      await Future.wait([
        cubit.refreshAllData(),
        categoriesCubit.fetchCategories(),
      ]);
    } catch (e) {
      // Handle any cubit access errors
      log('Error refreshing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowContent) {
      return const Center(
        child: Text('Loading...'),
      );
    }

    try {
      final cubit = context.read<ClientHomeTapCubit>();

      if (cubit.state is ClientHomeTapInitial ||
          cubit.state is ClientHomeTapTopRatedFailure ||
          cubit.state is ClientHomeTapInerstedProjectsFailure ||
          cubit.state is ClientHomeTapAllDataFailure) {
        cubit.getAllData();
        BlocProvider.of<GetCategoriesAndServicesCubit>(context)
            .fetchCategories();
      }

      return RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: CustomScrollView(
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 24.h),
            ),
            // "Top rated teams" section
            SliverToBoxAdapter(
              child: ReusableTextStyleMethods.poppins14BoldMethod(
                      context: context, text: context.tr('top_rated_teams'))
                  .paddingSymmetric(horizontal: 24.w),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 16.h),
            ),
            const SliverToBoxAdapter(
              child: TopTeamsSectionBuilder(),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    thickness: 0.2,
                  ).paddingSymmetric(horizontal: 24.w),
                  SizedBox(height: 8.h),
                  ReusableTextStyleMethods.poppins14BoldMethod(
                          context: context,
                          text: context.tr('explore_all_services'))
                      .paddingSymmetric(horizontal: 24.w),
                  ReusableTextStyleMethods.poppins12RegularMethod(
                          context: context,
                          text: context.tr('services_description'))
                      .paddingSymmetric(horizontal: 24.w),
                  SizedBox(height: 16.h),
                  const ExploreServicesSectionBuilder(),
                ],
              ),
            ),

            // Grid view for services
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              sliver: BlocBuilder<ClientHomeTapCubit, ClientHomeTapState>(
                builder: (context, state) {
                  if (state is ClientHomeTapInerstedProjectsLoading ||
                      state is ClientHomeTapAllDataLoading) {
                    return SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 16.w,
                        childAspectRatio: 0.98,
                      ),
                      itemBuilder: (context, index) => const ProjectsShimmer(),
                      itemCount: 6, // Show 6 shimmer items while loading
                    );
                  } else if (state is ClientHomeTapInerstedProjectsFailure) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(state.errMessage),
                      ),
                    );
                  } else if (state is ClientHomeTapInerstedProjectsSuccess) {
                    final List<ProjectModel> projects = state.projects;
                    if (projects.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text('No  found'),
                        ),
                      );
                    }
                    return SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 16.w,
                        childAspectRatio: 0.98,
                      ),
                      itemBuilder: (context, index) =>
                          ProjectInspirationViewCard(
                        projectModel: projects[index],
                      ),
                      itemCount: projects.length,
                    );
                  } else if (state is ClientHomeTapAllDataSuccess) {
                    final List<ProjectModel> projects = state.projects;
                    if (projects.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text('No projects found'),
                        ),
                      );
                    }
                    return SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 16.w,
                        childAspectRatio: 0.98,
                      ),
                      itemBuilder: (context, index) =>
                          ProjectInspirationViewCard(
                        projectModel: projects[index],
                      ),
                      itemCount: projects.length,
                    );
                  } else if (state is ClientHomeTapAllDataFailure) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(state.errMessage),
                      ),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text('Something went wrong'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      // Fallback if ClientHomeTapCubit is not available
      return const Center(
        child: Text('Content not available for current role'),
      );
    }
  }
}

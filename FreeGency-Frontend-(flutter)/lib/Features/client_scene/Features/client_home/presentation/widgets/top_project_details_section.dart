import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/view_model/project_inspiration/cubit/project_inspiration_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/shimmer_loading.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TopProjectDetailsSection extends StatelessWidget {
  const TopProjectDetailsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final projectModel = Get.arguments as ProjectModel;
    return BlocBuilder<ProjectInspirationCubit, ProjectInspirationState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: switch (state) {
            ProjectInspirationDataLoading() => _buildLoadingShimmer(context),
            ProjectInspirationDataError() => _buildErrorWidget(context, state),
            ProjectInspirationDataLoaded() =>
              _buildProjectDetails(context, state.projectModel),
            _ => _buildProjectDetails(context, projectModel),
          },
        );
      },
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Team logo and name shimmer
          Row(
            spacing: 4,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 120.w,
                height: 16.h,
                color: Colors.white,
              ),
            ],
          ),
          // Title shimmer
          Container(
            width: 250.w,
            height: 24.h,
            margin: EdgeInsets.only(top: 8.h),
            color: Colors.white,
          ),
          // Date shimmer
          Row(
            spacing: 6,
            children: [
              Container(
                width: 16.w,
                height: 16.h,
                margin: EdgeInsets.only(top: 6.h),
                color: Colors.white,
              ),
              Container(
                width: 80.w,
                height: 8.h,
                margin: EdgeInsets.only(top: 6.h),
                color: Colors.white,
              ),
            ],
          ),
          // Description shimmer
          Container(
            width: double.infinity,
            height: 40.h,
            margin: EdgeInsets.only(top: 8.h),
            color: Colors.white,
          ),
          // Details shimmer
          Row(
            children: [
              Expanded(
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.h,
                      margin: EdgeInsets.only(top: 8.h),
                      color: Colors.white,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.w,
                          height: 12.h,
                          margin: EdgeInsets.only(top: 8.h),
                          color: Colors.white,
                        ),
                        Container(
                          width: 40.w,
                          height: 8.h,
                          margin: EdgeInsets.only(top: 4.h),
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.h,
                      margin: EdgeInsets.only(top: 8.h),
                      color: Colors.white,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.w,
                          height: 12.h,
                          margin: EdgeInsets.only(top: 8.h),
                          color: Colors.white,
                        ),
                        Container(
                          width: 40.w,
                          height: 8.h,
                          margin: EdgeInsets.only(top: 4.h),
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(
      BuildContext context, ProjectInspirationDataError state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 48.sp,
          color: Theme.of(context).colorScheme.error,
        ),
        SizedBox(height: 8.h),
        Text(
          'Failed to load project details',
          style: AppTextStyles.poppins16Regular(context)!.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          state.failure.errorMessage,
          style: AppTextStyles.poppins12Regular(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProjectDetails(BuildContext context, ProjectModel projectModel) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // publisher Team details section
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.specificTeamProfile,
                arguments: projectModel.team);
          },
          child: Row(
            spacing: 4,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: projectModel.team?.logo ?? '',
                  width: 30.w,
                  height: 30.h,
                  fit: BoxFit.cover,
                ),
              ),
              ReusableTextStyleMethods.poppins16RegularMethod(
                  context: context,
                  text: projectModel.team?.name ?? 'Anonymous'),
            ],
          ),
        ),
        // project details section (name, description, budget, Tags or skills ...etc)
        ReusableTextStyleMethods.poppins24BoldMethod(
            context: context, text: projectModel.title ?? 'No Title'),
        Row(
          spacing: 6,
          children: [
            Icon(
              Iconsax.clock,
              size: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Text(
              projectModel.createdAt?.toLocal().toString() ?? 'No Date',
              style: AppTextStyles.poppins12Regular(context)!
                  .copyWith(fontSize: 8),
            ),
          ],
        ),
        Text(
          projectModel.description ?? 'No Description',
          style: AppTextStyles.poppins12Regular(context),
        ),
        Row(
          children: [
            SomeProjectDetailsListTile(
              icon: Iconsax.coin,
              label: '${projectModel.budget} USD',
              description: 'Project Price',
            ),
            SomeProjectDetailsListTile(
              icon: Iconsax.lamp_on,
              label: projectModel.category?.name ?? 'No Category',
              description: projectModel.service?.name ?? '',
            ),
          ],
        )
      ],
    );
  }
}

class SomeProjectDetailsListTile extends StatelessWidget {
  const SomeProjectDetailsListTile({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        spacing: 8,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.poppins12Regular(context)!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                description,
                style: AppTextStyles.poppins12Regular(context)!
                    .copyWith(fontSize: 8),
              ),
            ],
          )
        ],
      ),
    );
  }
}

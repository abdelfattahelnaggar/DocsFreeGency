
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/models/join_team_response_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/presentation/view_model/cubit/join_team_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class BuildRequestContent extends StatelessWidget {
  const BuildRequestContent({
    super.key,
    required this.requestId,
    required this.request,
  });

  final String requestId;
  final JoinTeamResponseModel request;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User Avatar
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 40.r,
            backgroundImage: NetworkImage(request.user?.profileImage ?? ''),
            onBackgroundImageError: (_, __) {},
            child: request.user?.profileImage?.isEmpty ?? true
                ? Icon(
                    Icons.person,
                    size: 40.sp,
                    color: Colors.grey,
                  )
                : null,
          ),
        ),
        SizedBox(height: 16.h),
    
        // User Name
        Text(
          request.user?.name ?? '',
          style: AppTextStyles.poppins20Bold(context),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
    
        // User Email
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            request.user?.email ?? '',
            style: AppTextStyles.poppins14Regular(context)!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        SizedBox(height: 16.h),
    
        // Job Position
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('requested_position'),
                style: AppTextStyles.poppins14Regular(context)!.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                request.job ?? '',
                style: AppTextStyles.poppins16Bold(context),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
    
        // Action Buttons
        if (context.read<JoinTeamCubit>().state is! JoinTeamLoading)
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<JoinTeamCubit>().rejectJoinRequest(requestId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    context.tr('reject'),
                    style: AppTextStyles.poppins16Bold(context)!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<JoinTeamCubit>().acceptJoinRequest(requestId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    context.tr('accept'),
                    style: AppTextStyles.poppins16Bold(context)!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          const CircularProgressIndicator(),
      ],
    );
  }
}
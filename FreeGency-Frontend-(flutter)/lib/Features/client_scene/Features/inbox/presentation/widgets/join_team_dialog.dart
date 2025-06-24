import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/data/models/join_team_response_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/join_team/presentation/view_model/cubit/join_team_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/widgets/build_error_content.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/widgets/build_request_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
class JoinTeamDialog extends StatelessWidget {
  final String requestId;

  const JoinTeamDialog({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinTeamCubit, JoinTeamState>(
      listener: (context, state) {
        if (state is JoinTeamSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is JoinTeamError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.group_add,
                      color: Theme.of(context).primaryColor,
                      size: 28.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        context.tr('join_team_request'),
                        style: AppTextStyles.poppins20Bold(context),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                if (state is GetSpecificJoinRequestLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: const CircularProgressIndicator(),
                  )
                else if (state is GetSpecificJoinRequestError)
                  _buildErrorContent(context, state.errorMessage)
                else if (state is GetSpecificJoinRequestSuccess)
                  _buildRequestContent(context, state.joinTeamResponseModel)
                else
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: const CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorContent(BuildContext context, String error) {
    return BuildErrorContent(error: error);
  }

  Widget _buildRequestContent(
      BuildContext context, JoinTeamResponseModel request) {
    return BuildRequestContent(requestId: requestId, request: request);
  }
}
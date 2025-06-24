import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/required_skils_selector.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/post_app_bar.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/data/models/post_job_request_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/presentation/view_model/cubit/post_job_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:get/get.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _validateForm(BuildContext context) {
    final cubit = context.read<PostJobCubit>();

    // Validate title
    if (cubit.titleController.text.trim().isEmpty) {
      showAppSnackBar(
        context,
        message: '⚠️ Please enter a title for your job',
        type: SnackBarType.info,
      );
      return false;
    }

    // Validate description
    if (cubit.descriptionController.text.trim().length < 10) {
      showAppSnackBar(
        context,
        message: '⚠️ Description must be at least 10 characters long',
        type: SnackBarType.info,
      );
      return false;
    }

    // Validate required skills
    if (cubit.requiredSelectedSkills.isEmpty) {
      showAppSnackBar(
        context,
        message: '⚠️ Please select at least one required skill',
        type: SnackBarType.info,
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostJobCubit, PostJobState>(
      listener: (context, state) {
        if (state is PostJobSuccess) {
          showAppSnackBar(
            context,
            message: '✅ Job posted successfully',
            type: SnackBarType.success,
          );
          // Clear all fields
          context.read<PostJobCubit>().clearAllFields();
          // Go back to previous screen
          Get.back();
        } else if (state is PostJobError) {
          showAppSnackBar(
            context,
            message: '❌ Failed to post job: ${state.errorMessage}',
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<PostJobCubit>();
        final bool isLoading = state is PostJobLoading;

        return Scaffold(
          appBar: const PostAppBar(title: 'post_job'),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.h.height,

                    // Job Title Field
                    ReusableTextStyleMethods.poppins16RegularMethod(
                      context: context,
                      text: context.tr('job_title'),
                    ),
                    8.h.height,
                    CustomTextField(
                      controller: cubit.titleController,
                      hintText: context.tr('job_title_hint'),
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Job title is required';
                        }
                        return null;
                      },
                    ),
                    16.h.height,

                    // Job Description Field
                    ReusableTextStyleMethods.poppins16RegularMethod(
                      context: context,
                      text: context.tr('job_description'),
                    ),
                    8.h.height,
                    CustomTextField(
                      controller: cubit.descriptionController,
                      hintText: context.tr('job_description_hint'),
                      textInputType: TextInputType.text,
                      maxLength: 500,
                      maxLines: 6,
                      validator: (value) {
                        if (value == null || value.trim().length < 10) {
                          return 'Description must be at least 10 characters long';
                        }
                        return null;
                      },
                    ),
                    16.h.height,

                    // Required Skills Field
                    ReusableTextStyleMethods.poppins16RegularMethod(
                      context: context,
                      text: context.tr('required_skills'),
                    ),

                    // Use the original RequiredSkillSelector widget
                    RequiredSkillSelector(
                      requiredSelectedSkills: cubit.requiredSelectedSkills,
                      onSkillAdded: (skill) {
                        setState(() {
                          cubit.requiredSelectedSkills.add(skill);
                        });
                      },
                      onSkillRemoved: (skill) {
                        setState(() {
                          cubit.requiredSelectedSkills.remove(skill);
                        });
                      },
                    ),

                    40.h.height,

                    PrimaryCTAButton(
                      label: context.tr('post_job'),
                      onTap: isLoading
                          ? null
                          : () {
                              if (!_validateForm(context)) {
                                return;
                              }

                              cubit.postJob(
                                PostJobRequestModel(
                                  title: cubit.titleController.text.trim(),
                                  description:
                                      cubit.descriptionController.text.trim(),
                                  requiredSkills: cubit.requiredSelectedSkills,
                                ),
                              );
                            },
                      child: isLoading
                          ? const AppLoadingIndicator(
                              color: Colors.white,
                            )
                          : null,
                    ),
                    20.h.height,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

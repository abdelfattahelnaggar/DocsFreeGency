import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/data/models/post_task_request_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/data/repositories/implementation_post_task_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/view_models/cubits/post_task_from_client_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/budget_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/category_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/date_input_textfield.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/post_app_bar.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/required_skils_selector.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/upload_related_files_section.dart';
import 'package:freegency_gp/core/shared/data/repositories/categories_and_services_repositories/implement_categories_and_services_repositories.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class PostTaskScreen extends StatefulWidget {
  const PostTaskScreen({super.key});

  @override
  State<PostTaskScreen> createState() => _PostTaskScreenState();
}

class _PostTaskScreenState extends State<PostTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isFixedPrice = true;
  late PostTaskFromClientCubit _postTaskCubit;
  late GetCategoriesAndServicesCubit _categoriesCubit;

  @override
  void initState() {
    super.initState();
    _postTaskCubit = PostTaskFromClientCubit(PostTaskRepoImplementation());
    _categoriesCubit = GetCategoriesAndServicesCubit(
      CategoriesAndServicesRepositoriesImplementation(),
    )..fetchCategoriesAndServicesModel();
  }

  @override
  void dispose() {
    // Explicitly close the cubits when the screen is disposed
    _postTaskCubit.close();
    _categoriesCubit.close();
    super.dispose();
  }

  bool _validateForm(BuildContext context) {
    final cubit = context.read<PostTaskFromClientCubit>();

    // Validate title
    if (cubit.titleController.text.trim().isEmpty) {
      showAppSnackBar(
        context,
        message: '⚠️ Please enter a title for your task',
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

    // Validate budget
    final budget = double.tryParse(cubit.budgetController.text.trim());
    if (budget == null || budget <= 0) {
      showAppSnackBar(
        context,
        message: '⚠️ Please enter a valid budget amount',
        type: SnackBarType.info,
      );
      return false;
    }

    // Validate category and service
    final categoryId =
        context.read<GetCategoriesAndServicesCubit>().selectedCategoryId;
    final serviceId =
        context.read<GetCategoriesAndServicesCubit>().selectedServiceId;
    if (categoryId == null || serviceId == null) {
      showAppSnackBar(
        context,
        message: '⚠️ Please select category and service',
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

    // Validate deadline
    if (cubit.deadlineController.text.trim().isEmpty) {
      showAppSnackBar(
        context,
        message: '⚠️ Please select a deadline',
        type: SnackBarType.info,
      );
      return false;
    }

    // Validate deadline is not in the past
    final deadline = _parseDeadline(cubit.deadlineController.text);
    if (deadline.isBefore(DateTime.now())) {
      showAppSnackBar(
        context,
        message: '⚠️ Deadline cannot be in the past',
        type: SnackBarType.info,
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _postTaskCubit,
        ),
        BlocProvider.value(
          value: _categoriesCubit,
        ),
      ],
      child: BlocConsumer<PostTaskFromClientCubit, PostTaskFromClientState>(
        listener: (context, state) {
          if (state is PostTaskFromClientSuccess) {
            showAppSnackBar(
              context,
              message: '✅ Task posted successfully',
              type: SnackBarType.success,
            );
            // Clear all fields
            context.read<PostTaskFromClientCubit>().clearAllFields();
            // Clear category and service selection
            context.read<GetCategoriesAndServicesCubit>().clearSelection();
          } else if (state is PostTaskFromClientError) {
            showAppSnackBar(
              context,
              message: '❌ Failed to post task: ${state.errorMessage}',
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<PostTaskFromClientCubit>();
          final bool isLoading = state is PostTaskFromClientLoading;

          return Scaffold(
            appBar: const PostAppBar(title: 'post_new_task'),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: context.tr('project_title'),
                      ),
                      8.h.height,
                      CustomTextField(
                        controller: cubit.titleController,
                        hintText: context.tr('project_title_hint'),
                        textInputType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                      16.h.height,

                      // Project Description Field
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: context.tr('project_description'),
                      ),
                      8.h.height,
                      CustomTextField(
                        controller: cubit.descriptionController,
                        hintText: context.tr('project_description_hint'),
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
                      8.h.height,

                      // Budget Field
                      BudgetSection(
                        budgetController: cubit.budgetController,
                        isFixedPrice: _isFixedPrice,
                        onPriceTypeChanged: (isFixed) {
                          setState(() {
                            _isFixedPrice = isFixed;
                          });
                        },
                      ),
                      8.height,

                      // Category Field
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: context.tr('category'),
                      ),
                      8.h.height,
                      const CategorySection(),
                      8.h.height,

                      // Required Skills Field
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: context.tr('required_skills'),
                      ),

                      const RequiredSkillSelector(),

                      // Deadline Field
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: 'Deadline',
                      ),
                      8.h.height,
                      DateInputTextField(
                        controller: cubit.deadlineController,
                        hintText: 'YYYY/MM/DD',
                      ),

                      16.h.height,

                      const UploadRelatedFiles(),
                      16.h.height,
                      PrimaryCTAButton(
                        label: context.tr('post_task'),
                        onTap: isLoading
                            ? null
                            : () {
                                if (!_validateForm(context)) {
                                  return;
                                }

                                final categoryId = context
                                    .read<GetCategoriesAndServicesCubit>()
                                    .selectedCategoryId;
                                final serviceId = context
                                    .read<GetCategoriesAndServicesCubit>()
                                    .selectedServiceId;

                                cubit.postTask(
                                  PostTaskRequestModel(
                                    title: cubit.titleController.text.trim(),
                                    description:
                                        cubit.descriptionController.text.trim(),
                                    budget: double.tryParse(cubit
                                            .budgetController.text
                                            .trim()) ??
                                        0,
                                    requiredSkills:
                                        cubit.requiredSelectedSkills,
                                    category: categoryId!,
                                    service: 
                                    serviceId!
                                    ,
                                    deadline: _parseDeadline(
                                        cubit.deadlineController.text),
                                    isFixedPrice: _isFixedPrice,
                                    relatedFile: cubit.pickedFile,
                                  ),
                                );
                              },
                        child: isLoading
                            ? const AppLoadingIndicator(
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DateTime _parseDeadline(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        return DateTime(year, month, day, 23, 59, 59);
      }
    } catch (e) {
      log('Error parsing date: $e');
    }
    return DateTime.now().add(const Duration(days: 7));
  }
}

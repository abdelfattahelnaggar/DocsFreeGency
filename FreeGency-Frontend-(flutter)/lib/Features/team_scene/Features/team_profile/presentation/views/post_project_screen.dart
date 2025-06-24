import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/budget_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/category_section.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/date_input_textfield.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/post_app_bar.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/data/post_project_request_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/repositories/implementation_post_project_repo.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/view_models/cubits/post_project_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/widgets/technology_selector.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/widgets/upload_project_images.dart';
import 'package:freegency_gp/core/shared/data/repositories/categories_and_services_repositories/implement_categories_and_services_repositories.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class PostProjectScreen extends StatefulWidget {
  const PostProjectScreen({super.key});

  @override
  State<PostProjectScreen> createState() => _PostProjectScreenState();
}

class _PostProjectScreenState extends State<PostProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late PostProjectCubit _postProjectCubit;
  late GetCategoriesAndServicesCubit _categoriesCubit;

  @override
  void initState() {
    super.initState();
    _postProjectCubit = PostProjectCubit(PostProjectRepoImplementation());
    _categoriesCubit = GetCategoriesAndServicesCubit(
      CategoriesAndServicesRepositoriesImplementation(),
    )..fetchCategoriesAndServicesModel();
  }

  @override
  void dispose() {
    _postProjectCubit.close();
    _categoriesCubit.close();
    super.dispose();
  }

  bool _validateForm(BuildContext context) {
    final cubit = context.read<PostProjectCubit>();

    // Validate title
    if (cubit.titleController.text.trim().isEmpty) {
      showAppSnackBar(
        context,
        message: '⚠️ Please enter a title for your project',
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
    if (cubit.budgetController.text.trim().isEmpty) {
      showAppSnackBar(
        context,
        message: '⚠️ Please enter a budget for your project',
        type: SnackBarType.info,
      );
      return false;
    }

    double? budget = double.tryParse(cubit.budgetController.text.trim());
    if (budget == null || budget <= 0) {
      showAppSnackBar(
        context,
        message: '⚠️ Please enter a valid budget amount',
        type: SnackBarType.info,
      );
      return false;
    }

    // Validate project URL
    if (cubit.projectUrlController.text.trim().isEmpty) {
      showAppSnackBar(
        context,
        message: '⚠️ Please enter a project URL',
        type: SnackBarType.info,
      );
      return false;
    }

    // Validate technologies
    if (cubit.selectedTechnologies.isEmpty) {
      showAppSnackBar(
        context,
        message: '⚠️ Please select at least one technology',
        type: SnackBarType.info,
      );
      return false;
    }

    // Validate completion date
    if (cubit.completionDateController.text.trim().isEmpty) {
      showAppSnackBar(
        context,
        message: '⚠️ Please select a completion date',
        type: SnackBarType.info,
      );
      return false;
    }

    // Validate service selection
    final categoryId =
        context.read<GetCategoriesAndServicesCubit>().selectedCategoryId;
    final serviceId =
        context.read<GetCategoriesAndServicesCubit>().selectedServiceId;

    if (categoryId == null || serviceId == null) {
      showAppSnackBar(
        context,
        message: '⚠️ Please select a service category',
        type: SnackBarType.info,
      );
      return false;
    }

    return true;
  }

  void _submitProject(BuildContext context) {
    if (!_validateForm(context)) {
      return;
    }

    final cubit = context.read<PostProjectCubit>();
    final serviceId =
        context.read<GetCategoriesAndServicesCubit>().selectedServiceId!;

    try {
      DateTime completionDate =
          DateFormat('yyyy/MM/dd').parse(cubit.completionDateController.text);
      double budget = double.parse(cubit.budgetController.text.trim());

      final request = PostProjectRequestModel(
        title: cubit.titleController.text.trim(),
        description: cubit.descriptionController.text.trim(),
        budget: budget,
        projectUrl: cubit.projectUrlController.text.trim(),
        technologies: cubit.selectedTechnologies,
        completionDate: completionDate,
        service: serviceId,
        images: cubit.pickedImages,
      );

      cubit.postProject(request);
    } catch (e) {
      log('Error creating project request: $e');
      showAppSnackBar(
        context,
        message: '❌ Error processing project data: $e',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _postProjectCubit),
        BlocProvider.value(value: _categoriesCubit),
      ],
      child: BlocConsumer<PostProjectCubit, PostProjectState>(
        listener: (context, state) {
          if (state is PostProjectSuccess) {
            showAppSnackBar(
              context,
              message: '✅ Project posted successfully',
              type: SnackBarType.success,
            );
            // Clear all fields
            context.read<PostProjectCubit>().clearAllFields();
            // Clear category and service selection
            context.read<GetCategoriesAndServicesCubit>().clearSelection();
          } else if (state is PostProjectError) {
            showAppSnackBar(
              context,
              message: '❌ Failed to post project: ${state.errorMessage}',
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<PostProjectCubit>();
          final bool isLoading = state is PostProjectLoading;

          return Scaffold(
            appBar: const PostAppBar(title: 'Post New Project'),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Title
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: 'Project Title',
                      ),
                      8.h.height,
                      CustomTextField(
                        controller: cubit.titleController,
                        hintText: 'Enter your project title',
                        textInputType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                      16.h.height,

                      // Project Description
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: 'Project Description',
                      ),
                      8.h.height,
                      CustomTextField(
                        controller: cubit.descriptionController,
                        hintText: 'Describe your project in detail',
                        textInputType: TextInputType.multiline,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().length < 10) {
                            return 'Description must be at least 10 characters';
                          }
                          return null;
                        },
                      ),
                      16.h.height,

                      // Budget Section
                      BudgetSection(
                        isFixedPrice:
                            true, // Projects are typically fixed price
                        budgetController: cubit.budgetController,
                        onPriceTypeChanged: (isFixed) {
                          // Handle price type change if needed
                        },
                      ),
                      16.h.height,

                      // Project URL
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: 'Project URL',
                      ),
                      8.h.height,
                      CustomTextField(
                        controller: cubit.projectUrlController,
                        hintText: 'https://example.com/your-project',
                        textInputType: TextInputType.url,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Project URL is required';
                          }
                          return null;
                        },
                      ),
                      16.h.height,

                      // Service Category Selection
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: 'Service Category',
                      ),
                      8.h.height,
                      const CategorySection(),
                      16.h.height,

                      // Technologies Section
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: 'Technologies Used',
                      ),
                      BlocBuilder<PostProjectCubit, PostProjectState>(
                        buildWhen: (previous, current) =>
                            current is TechnologiesUpdated ||
                            current is PostProjectInitial,
                        builder: (context, state) {
                          return TechnologySelector(
                            selectedTechnologies: cubit.selectedTechnologies,
                            onTechnologyAdded: cubit.addTechnology,
                            onTechnologyRemoved: cubit.removeTechnology,
                          );
                        },
                      ),
                      16.h.height,

                      // Completion Date
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: 'Completion Date',
                      ),
                      8.h.height,
                      DateInputTextField(
                        controller: cubit.completionDateController,
                        hintText: 'YYYY/MM/DD',
                      ),
                      16.h.height,

                      // Project Images
                      ReusableTextStyleMethods.poppins16RegularMethod(
                        context: context,
                        text: 'Project Images',
                      ),
                      8.h.height,
                      const UploadProjectImages(),
                      24.h.height,

                      // Submit Button
                      PrimaryCTAButton(
                        label: 'Post Project',
                        onTap: isLoading ? null : () => _submitProject(context),
                      ),
                      24.h.height,
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
}

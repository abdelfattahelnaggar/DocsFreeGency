import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/choose_interests_cubit/choose_interests_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/choose_interests_cubit/choose_interests_state.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/header_section.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/interest_item.dart';
import 'package:freegency_gp/core/shared/data/models/categories_and_its_services_model.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';

class ChooseInterestsScreen extends StatefulWidget {
  static const String routeName = AppRoutes.chooseInterests;
  final bool editMode;
  const ChooseInterestsScreen({super.key, this.editMode = false});

  @override
  State<ChooseInterestsScreen> createState() => _ChooseInterestsScreenState();
}

class _ChooseInterestsScreenState extends State<ChooseInterestsScreen> {
  bool _isLoading = false;
  bool _interestsSaved = false;

  @override
  void initState() {
    super.initState();
    context
        .read<GetCategoriesAndServicesCubit>()
        .fetchCategoriesAndServicesModel();

    if (widget.editMode) {
      _loadCurrentUserInterests();
    }
  }

  Future<void> _loadCurrentUserInterests() async {
    final user = await LocalStorage.getUserData();
    if (user != null && user.interests.isNotEmpty) {
      final interestIds = user.interests.map((e) => e.id).toList();
      context.read<ChooseInterestsCubit>().setInitialInterests(interestIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final interestsCubit = context.read<ChooseInterestsCubit>();

    return Scaffold(
      body: SafeArea(
        child: BlocListener<ChooseInterestsCubit, ChooseInterestsState>(
          listener: (context, state) {
            if (state is ChooseInterestsLoading) {
              setState(() {
                _isLoading = true;
              });
            } else {
              setState(() {
                _isLoading = false;
              });

              if (state is ChooseInterestsSuccess) {
                showAppSnackBar(
                  context,
                  message: "Your interests have been saved successfully!",
                  type: SnackBarType.success,
                );

                // Navigate after a short delay to allow the user to see the success message
                Future.delayed(const Duration(milliseconds: 1500), () {
                  _interestsSaved = true;
                  _navigateToHome(context);
                });
              } else if (state is ChooseInterestsFailure) {
                showAppSnackBar(
                  context,
                  message: state.errorMessage,
                  type: SnackBarType.error,
                  actionLabel: "Try Again",
                  onAction: () {
                    if (interestsCubit.state.selectedInterests.isNotEmpty) {
                      interestsCubit.sendInterests(
                          interestsCubit.state.selectedInterests);
                    }
                  },
                );
              }
            }
          },
          child: Stack(
            children: [
              Column(
                children: [
                  HeaderSection(
                    onSkipPressed: () => _skipInterests(context),
                  ),
                  const SizedBox(height: 10),

                  // Interest selection counter
                  BlocBuilder<ChooseInterestsCubit, ChooseInterestsState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select your interests:',
                              style: AppTextStyles.poppins16Bold(context),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: state.selectedInterests.isEmpty
                                    ? Colors.grey.withValues(alpha: 0.2)
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${state.selectedInterests.length} selected',
                                style: AppTextStyles.poppins14Regular(context)
                                    ?.copyWith(
                                  color: state.selectedInterests.isEmpty
                                      ? Colors.grey
                                      : Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  Expanded(
                    child: BlocBuilder<GetCategoriesAndServicesCubit,
                        GetCategoriesAndServicesState>(
                      builder: (context, state) {
                        if (state is GetCategoriesAndServicesLoading) {
                          return const Center(child: AppLoadingIndicator());
                        } else if (state is GetCategoriesAndServicesError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(state.errorMessage),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<GetCategoriesAndServicesCubit>()
                                        .fetchCategoriesAndServicesModel();
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else if (state is GetCategoriesAndServicesSuccess) {
                          // Handle both List and CategoriesAndItsServicesModel types
                          List<CategoryModel> categories = [];

                          if (state.data is CategoriesAndItsServicesModel) {
                            final categoriesModel =
                                state.data as CategoriesAndItsServicesModel;
                            categories = categoriesModel.data;
                          } else if (state.data is List) {
                            try {
                              // Try to cast each item to CategoryModel
                              categories = (state.data as List)
                                  .map((item) {
                                    if (item is CategoryModel) {
                                      return item;
                                    } else if (item is Map<String, dynamic>) {
                                      try {
                                        return CategoryModel.fromJson(item);
                                      } catch (e) {
                                        // Log the error but continue processing
                                        // print('Error parsing category: $e');
                                        // print('Item data: $item');
                                        // Return a placeholder category to avoid breaking the UI
                                        return CategoryModel(
                                          id: 'error',
                                          name:
                                              'Error: ${e.toString().substring(0, math.min(20, e.toString().length))}...',
                                          status: 'error',
                                          services: [],
                                          servicesCount: 0,
                                          color: '#FF0000',
                                          image: null,
                                        );
                                      }
                                    } else {
                                      // For completely invalid items
                                      // print(
                                      //     'Invalid item type: ${item.runtimeType}');
                                      // print('Item data: $item');
                                      return CategoryModel(
                                        id: 'invalid-${item.hashCode}',
                                        name: 'Invalid Data Type',
                                        status: 'error',
                                        services: [],
                                        servicesCount: 0,
                                        color: '#FF0000',
                                        image: null,
                                      );
                                    }
                                  })
                                  .where((category) => category.id != 'error')
                                  .toList();
                            } catch (e) {
                              return Center(
                                child: Text(
                                    'Error parsing categories: ${e.toString()}'),
                              );
                            }
                          } else {
                            // Handle unknown data type
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Unexpected data format: ${state.data.runtimeType}'),
                                  const SizedBox(height: 12),
                                  Text('Data: ${state.data.toString()}'),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<GetCategoriesAndServicesCubit>()
                                          .fetchCategoriesAndServicesModel();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (categories.isEmpty) {
                            return const Center(
                              child: Text(
                                  'No categories available. Try again later.'),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return BlocBuilder<ChooseInterestsCubit,
                                  ChooseInterestsState>(
                                builder: (context, interestsState) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: InterestItem(
                                      title: category.name,
                                      description:
                                          'Services available: ${category.servicesCount}',
                                      isSelected: interestsState
                                          .selectedInterests
                                          .contains(category.id),
                                      onTap: _isLoading
                                          ? null
                                          : () => interestsCubit
                                              .toggleInterest(category.id),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                        return const Center(
                            child: Text('Select your interests'));
                      },
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppLoadingIndicator(
                            size: 60, color: Colors.white),
                        const SizedBox(height: 24),
                        Text(
                          'Sending your interests...',
                          style: AppTextStyles.poppins16Bold(context)?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'This will only take a moment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          BlocBuilder<ChooseInterestsCubit, ChooseInterestsState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: 100,
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.all(15),
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppLoadingIndicator(size: 30),
                      const SizedBox(height: 10),
                      Text(
                        'Saving your interests...',
                        style:
                            AppTextStyles.poppins14Regular(context)?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  )
                : PrimaryCTAButton(
                    label: 'Done',
                    onTap: () => _checkEmptyInterests(context),
                  ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (!widget.editMode && !_interestsSaved) {
      LocalStorage.clearAuthData();
    }
    super.dispose();
  }

  void _navigateToHome(BuildContext context) {
    if (widget.editMode) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.userLogin,
        (route) => false,
      );
    }
  }

  void _skipInterests(BuildContext context) {
    showAppSnackBar(
      context,
      message: "Skipping interests selection",
      type: SnackBarType.info,
    );

    // Navigate after a short delay to allow the user to see the info message
    Future.delayed(const Duration(milliseconds: 1000), () {
      _navigateToHome(context);
    });
  }

  void _checkEmptyInterests(BuildContext context) {
    final interestsCubit = context.read<ChooseInterestsCubit>();
    if (interestsCubit.state.selectedInterests.isEmpty) {
      // Show a warning if no interests selected
      showAppSnackBar(
        context,
        message: "Please select at least one interest or skip",
        type: SnackBarType.info,
        actionLabel: "Skip",
        onAction: () => _navigateToHome(context),
      );
    } else {
      // Send selected interests to the backend
      interestsCubit.sendInterests(interestsCubit.state.selectedInterests);
    }
  }
}

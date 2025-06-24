import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/available_jobs/presentation/view_model/available_jobs_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/available_jobs/presentation/widgets/available_jobs_cards_builder.dart';
import 'package:freegency_gp/Features/client_scene/Features/available_jobs/presentation/widgets/custom_jobs_tab_bar.dart';
import 'package:freegency_gp/core/shared/data/models/categories_and_its_services_model.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/keep_alive_page.dart';
import 'package:iconsax/iconsax.dart';

class JobsTap extends StatefulWidget {
  const JobsTap({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<JobsTap> createState() => _JobsTapState();
}

class _JobsTapState extends State<JobsTap> with TickerProviderStateMixin {
  late TabController _tabController;
  List<CategoryModel> categories = [];
  bool isLoadingCategories = true;

  // Fixed icons for categories (will cycle through these)
  final List<IconData> availableIcons = [
    Iconsax.flash_1,
    Iconsax.monitor,
    Iconsax.flag_2,
    Iconsax.brush_4,
    Iconsax.hierarchy,
    Iconsax.code_1,
    Iconsax.paintbucket,
    Iconsax.mobile,
  ];

  List<IconData> get icons {
    List<IconData> iconsList = [
      Iconsax.flash_1
    ]; // First icon for "For You Jobs"
    for (int i = 0; i < categories.length; i++) {
      iconsList.add(availableIcons[(i + 1) % availableIcons.length]);
    }
    return iconsList;
  }

  List<String> get labels {
    List<String> labelsList = ['For You Jobs'];
    labelsList.addAll(categories.map((category) => category.name).toList());
    return labelsList;
  }

  List<String?> get categoryIds {
    List<String?> idsList = [null]; // null for "For You Jobs"
    idsList.addAll(categories.map((category) => category.id).toList());
    return idsList;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this); // Start with 1 tab
    _tabController.addListener(_onTabChanged);
    _fetchCategories();
  }

  void _onTabChanged() {
    setState(() {}); // Rebuild UI

    // Fetch jobs for the newly selected tab
    if (_tabController.index < categoryIds.length) {
      final selectedCategoryId = categoryIds[_tabController.index];
      log('📑 Tab changed to index: ${_tabController.index}, categoryId: $selectedCategoryId');

      // Trigger a new fetch for the selected category
      if (mounted) {
        // Use a slight delay to ensure the UI is built first
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            context
                .read<AvailableJobsCubit>()
                .getAvailableJobs(categoryId: selectedCategoryId);
          }
        });
      }
    }
  }

  void _fetchCategories() {
    if (mounted) {
      context.read<GetCategoriesAndServicesCubit>().fetchCategories();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetCategoriesAndServicesCubit,
        GetCategoriesAndServicesState>(
      listener: (context, state) {
        log('🔥 GetCategoriesAndServicesState: $state'); // Debug log
        if (state is GetCategoriesAndServicesSuccess) {
          log('✅ Success state data type: ${state.data.runtimeType}'); // Debug log
          if (state.data is List<CategoryModel>) {
            final categoriesList = state.data as List<CategoryModel>;
            log('📝 Categories loaded: ${categoriesList.length}'); // Debug log
            setState(() {
              categories = categoriesList;
              isLoadingCategories = false;
              _tabController.dispose();
              _tabController =
                  TabController(length: labels.length, vsync: this);
              _tabController.addListener(_onTabChanged);
            });

            // Fetch initial data for the first tab (For You Jobs)
            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted && categoryIds.isNotEmpty) {
                context
                    .read<AvailableJobsCubit>()
                    .getAvailableJobs(categoryId: categoryIds[0]);
              }
            });
          } else if (state.data is CategoriesAndItsServicesModel) {
            final categoriesModel = state.data as CategoriesAndItsServicesModel;
            log('📝 Categories from model: ${categoriesModel.data.length}'); // Debug log
            setState(() {
              categories = categoriesModel.data;
              isLoadingCategories = false;
              _tabController.dispose();
              _tabController =
                  TabController(length: labels.length, vsync: this);
              _tabController.addListener(_onTabChanged);
            });

            // Fetch initial data for the first tab (For You Jobs)
            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted && categoryIds.isNotEmpty) {
                context
                    .read<AvailableJobsCubit>()
                    .getAvailableJobs(categoryId: categoryIds[0]);
              }
            });
          }
        } else if (state is GetCategoriesAndServicesError) {
          log('❌ Error: ${state.errorMessage}'); // Debug log
          setState(() {
            isLoadingCategories = false;
          });
        } else if (state is GetCategoriesAndServicesLoading) {
          log('⏳ Loading categories...'); // Debug log
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: CustomTabBarForJobs(
                icons: icons, tabController: _tabController, labels: labels),
          ),
          Expanded(
            child: KeepAliveTabBarView(
              controller: _tabController,
              children: List.generate(
                labels.length,
                (index) {
                  return AvailableJobsCardsBuilder(
                    scrollController: widget.scrollController,
                    categoryId: categoryIds[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
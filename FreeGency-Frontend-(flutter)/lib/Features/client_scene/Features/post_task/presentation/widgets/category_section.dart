import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/shared/data/models/categories_and_its_services_model.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  void initState() {
    super.initState();
    // Fetch will be done by the parent widget, no need to call it here
  }

  void _showCategoryDialog() {
    // Get a reference to the cubit before showing the dialog
    final categoriesCubit = context.read<GetCategoriesAndServicesCubit>();
    final state = categoriesCubit.state;

    if (state is! GetCategoriesAndServicesSuccess) {
      // If data isn't loaded yet, show loading indicator briefly and return
      showDialog(
        context: context,
        builder: (dialogContext) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: AppLoadingIndicator(),
            ),
          );
        },
      );

      // Fetch data if needed
      if (state is! GetCategoriesAndServicesLoading) {
        categoriesCubit.fetchCategoriesAndServicesModel();
      }
      return;
    }

    // If we have data, show the selection dialog
    final categoriesAndServicesModel =
        (state.data as CategoriesAndItsServicesModel).data;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Container(
            width: double.infinity,
            height: 600.h,
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categoriesAndServicesModel.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 16.w),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.2),
                        child: Text(
                          category.name,
                          style: AppTextStyles.poppins20Bold(context),
                        ),
                      ),
                      ...List<Widget>.from(category.services.map((service) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              categoriesCubit.selectedCategory = category.name;
                              categoriesCubit.selectedService = service.name;
                              categoriesCubit.selectedCategoryId = category.id;
                              categoriesCubit.selectedServiceId = service.id;
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 16.w),
                              width: double.infinity,
                              height: 50.h,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  service.name,
                                  style:
                                      AppTextStyles.poppins16Regular(context)!
                                          .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }))
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the cubit from the parent context - avoid creating a new provider
    final categoriesCubit = context.watch<GetCategoriesAndServicesCubit>();

    String displayText = context.tr('select_service');
    if (categoriesCubit.selectedCategory != null &&
        categoriesCubit.selectedService != null) {
      displayText =
          '${categoriesCubit.selectedCategory} : ${categoriesCubit.selectedService}';
    }

    return GestureDetector(
      onTap: _showCategoryDialog,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayText,
              style: AppTextStyles.poppins14Regular(context),
            ),
          ],
        ),
      ),
    );
  }
}

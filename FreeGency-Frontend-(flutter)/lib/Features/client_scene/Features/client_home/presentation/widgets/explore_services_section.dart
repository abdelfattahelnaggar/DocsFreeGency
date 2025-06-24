import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/explore_services_card_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/explore_shimmer.dart';
import 'package:freegency_gp/core/shared/data/models/categories_and_its_services_model.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:get/get.dart';

class ExploreServicesSectionBuilder extends StatefulWidget {
  const ExploreServicesSectionBuilder({
    super.key,
  });

  @override
  State<ExploreServicesSectionBuilder> createState() =>
      _ExploreServicesSectionBuilderState();
}

class _ExploreServicesSectionBuilderState
    extends State<ExploreServicesSectionBuilder> {
  bool _isClient = false;
  bool _isGuest = false;
  bool _isTeamMember = false;
  bool _shouldShowContent = false;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    _isClient = await LocalStorage.isClient();
    _isGuest = await LocalStorage.isGuest();
    _isTeamMember = await LocalStorage.isTeamMember();
    _shouldShowContent =
        _isClient || _isGuest || _isTeamMember; // Show content for both client and guest
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Use the localized cards
    final localizedCards = ExploreServicesCardModel.getLocalizedCards(context);

    if (!_shouldShowContent) {
      // Show shimmer for non-client/non-guest roles
      return SizedBox(
        height: 170.h,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => ExploreServicesShimmer(
            color: localizedCards[index].color,
          ),
          separatorBuilder: (context, index) => 16.width,
          itemCount: localizedCards.length,
        ),
      );
    }

    try {
      return SizedBox(
        height: 170.h,
        child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => BlocBuilder<
                    GetCategoriesAndServicesCubit,
                    GetCategoriesAndServicesState>(
                  builder: (context, state) {
                    if (state is GetCategoriesAndServicesSuccess) {
                      final category = state.data[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.exploreServicesByCategory,
                              arguments: category);
                        },
                        child: ExploreServicesSection(
                          exploreObject: localizedCards[index],
                          category: category,
                        ),
                      );
                    } else if (state is GetCategoriesAndServicesError) {
                      return Center(
                        child: Text(
                          state.errorMessage,
                          style: AppTextStyles.poppins16Regular(context),
                        ),
                      );
                    } else {
                      return ExploreServicesShimmer(
                        color: localizedCards[index].color,
                      );
                    }
                  },
                ),
            separatorBuilder: (context, index) => 16.width,
            itemCount: localizedCards.length),
      );
    } catch (e) {
      // Fallback for any errors
      return SizedBox(
        height: 170.h,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => ExploreServicesShimmer(
            color: localizedCards[index].color,
          ),
          separatorBuilder: (context, index) => 16.width,
          itemCount: localizedCards.length,
        ),
      );
    }
  }
}

class ExploreServicesSection extends StatelessWidget {
  const ExploreServicesSection({
    super.key,
    required this.exploreObject,
    required this.category,
  });

  final ExploreServicesCardModel exploreObject;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final isRTL = context.locale.languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.all(16),
      width: Get.width * 0.75,
      height: 170.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: exploreObject.color,
      ),
      child: Stack(
        children: [
          Positioned(
            right: isRTL ? null : 0,
            left: isRTL ? 0 : null,
            child: CachedNetworkImage(
              imageUrl: category.image ??
                  'https://static.vecteezy.com/system/resources/previews/019/784/376/non_2x/people-icon-work-group-vector.jpg',
              fit: BoxFit.cover,
              width: 120.w,
              height: 140.h,
            ),
          ),
          Positioned(
            right: isRTL ? 0 : null,
            left: isRTL ? null : 0,
            child: SizedBox(
              width: Get.width * 0.4,
              child: Column(
                crossAxisAlignment:
                    isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    exploreObject.title,
                    style: TextStyle(
                      fontFamily: isRTL ? 'IBMPlexSansArabic' : 'Poppins',
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isRTL ? TextAlign.right : TextAlign.left,
                  ),
                  ReusableTextStyleMethods.poppins14RegularMethod(
                    context: context,
                    text: 'Discover +${category.servicesCount} services',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

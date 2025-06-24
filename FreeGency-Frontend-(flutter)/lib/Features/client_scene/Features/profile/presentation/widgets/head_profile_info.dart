import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/user_data_functionality_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/widgets/dialog_item.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class HeadProfileInfoSection extends StatelessWidget {
  const HeadProfileInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserDataFunctionalityCubit>();
    dialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DialogItem(
                  cubit: cubit,
                  icon: Icons.camera_alt_outlined,
                  text: 'Camera',
                ),
                DialogItem(
                  cubit: cubit,
                  icon: Icons.image_outlined,
                  text: 'Gallery',
                ),
              ],
            ),
          );
        },
      );
    }

    return BlocBuilder<UserDataFunctionalityCubit, UserDataFunctionalityState>(
      builder: (context, state) {
        if (state is GetUserDataError || state is GetAllUserDataError) {
          final errorMessage = state is GetUserDataError
              ? state.errorMessage
              : (state as GetAllUserDataError).errorMessage;
          return Center(
            child: Text(errorMessage),
          );
        }
        if (state is UserDataFunctionalityInitial ||
            state is GetAllUserDataLoading) {
          if (!cubit.hasData) {
            return const AppLoadingIndicator();
          }
        }

        if (state is GetUserDataLoading) {
          return const AppLoadingIndicator();
        }

        if (state is UploadImageLoading) {
          return const AppLoadingIndicator(size: 30);
        }

        String imageUrl = '';
        String name = '';
        String email = '';
        String role = 'Guest';
        bool isImageLoading = false;
        int? averageRating = 0;

        if (state is GetUserDataSuccess) {
          imageUrl = state.userModel.image ?? '';
          name = state.userModel.name ?? '';
          email = state.userModel.email ?? '';
          role = state.userModel.role ?? 'Guest';
        } else if (state is GetAllUserDataSuccess) {
          imageUrl = state.userModel.image ?? '';
          name = state.userModel.name ?? '';
          email = state.userModel.email ?? '';
          role = state.userModel.role ?? 'Guest';
          averageRating = state.userModel.averageRating;
        } else if (state is UploadImageLoading) {
          final cachedUserData = cubit.cachedUserData;
          if (cachedUserData != null) {
            imageUrl = cachedUserData.image ?? '';
            name = cachedUserData.name ?? '';
            email = cachedUserData.email ?? '';
            role = cachedUserData.role ?? 'Guest';
            averageRating = cachedUserData.averageRating;
          }
          isImageLoading = true;
        } else {
          final cachedUserData = cubit.cachedUserData;
          if (cachedUserData != null) {
            imageUrl = cachedUserData.image ?? '';
            name = cachedUserData.name ?? '';
            email = cachedUserData.email ?? '';
            role = cachedUserData.role ?? 'Guest';
            averageRating = cachedUserData.averageRating;
          }
        }
        return _buildProfileInfo(
            context, imageUrl, name, email, role, averageRating, dialog,
            isImageLoading: isImageLoading);
      },
    );
  }

  Widget _buildProfileInfo(BuildContext context, String imageUrl, String name,
      String email, String role, int? averageRating, Function dialog,
      {bool isImageLoading = false}) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => dialog(),
          child: Stack(
            children: [
              ClipOval(
                child: imageUrl.isEmpty
                    ? Container(
                        width: 126.w,
                        height: 126.h,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 50),
                      )
                    : CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 126.w,
                        height: 126.h,
                        fit: BoxFit.cover,
                        cacheKey:
                            '${imageUrl}_${DateTime.now().millisecondsSinceEpoch}',
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const AppLoadingIndicator(size: 30),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
              ),
              if (isImageLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const AppLoadingIndicator(
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        8.width,
        Expanded(
          flex: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableTextStyleMethods.poppins16BoldMethod(
                context: context,
                text: name,
              ),
              Text(
                email,
                style: AppTextStyles.poppins12Regular(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Stars of Rating
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xffFFE500),
                    size: 16,
                  ),
                  8.width,
                  ReusableTextStyleMethods.poppins12RegularMethod(
                    context: context,
                    text: "$averageRating",
                  ),
                ],
              ),
              // Role
              ReusableTextStyleMethods.poppins12RegularMethod(
                context: context,
                text: role,
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Iconsax.edit_2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

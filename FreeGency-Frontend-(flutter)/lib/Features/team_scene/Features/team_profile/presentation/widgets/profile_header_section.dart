import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/view_model/cubit/team_profile_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_snackbar.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ProfileHeaderSection extends StatefulWidget {
  const ProfileHeaderSection({super.key});

  @override
  State<ProfileHeaderSection> createState() => _ProfileHeaderSectionState();
}

class _ProfileHeaderSectionState extends State<ProfileHeaderSection> {
  // Local state to track image loading
  String? _selectedImagePath;
  bool _isUpdatingLogo = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamProfileCubit, TeamProfileState>(
        listener: (context, state) {
      if (state is TeamLogoUpdateSuccess) {
        // Reset local state
        setState(() {
          _selectedImagePath = null;
          _isUpdatingLogo = false;
        });

        // Clear image cache
        imageCache.clear();
        imageCache.clearLiveImages();

        // Refresh team profile to get updated logo
        context.read<TeamProfileCubit>().getMyTeamProfile();

        showAppSnackBar(
          context,
          message: state.message,
          type: SnackBarType.success,
        );
      } else if (state is TeamLogoUpdateError) {
        setState(() {
          _isUpdatingLogo = false;
        });

        showAppSnackBar(
          context,
          message: state.errorMessage,
          type: SnackBarType.error,
        );
      } else if (state is TeamLogoUpdateLoading) {
        setState(() {
          _isUpdatingLogo = true;
        });
      }
    }, builder: (context, state) {
      final cubit = context.read<TeamProfileCubit>();
      final team = cubit.myTeam;

      if (team == null && state is! TeamProfileError) {
        return const Center(child: AppLoadingIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          24.height,
          // Profile Image with edit button
          Center(
            child: Stack(
              children: [
                // Profile image
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: _selectedImagePath != null
                      // Show selected image if available
                      ? Image.file(
                          File(_selectedImagePath!),
                          width: 126.w,
                          height: 126.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                        )
                      : (team?.logo == null || team!.logo!.isEmpty)
                          // Show placeholder if no logo
                          ? _buildPlaceholder()
                          // Show network image if logo exists
                          : Image.network(
                              team.logo!,
                              width: 126.w,
                              height: 126.h,
                              fit: BoxFit.cover,
                              // Force image refresh by adding timestamp to URL
                              key: ValueKey(
                                  '${team.logo}-${DateTime.now().millisecondsSinceEpoch}'),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[300],
                                  width: 126.w,
                                  height: 126.h,
                                  child: const AppLoadingIndicator(size: 30),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholder();
                              },
                            ),
                ),
                // Edit button overlay
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _isUpdatingLogo
                        ? null
                        : () => _showImageSourceOptions(context),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: _isUpdatingLogo
                          ? const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Icon(
                              Iconsax.camera,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: ReusableTextStyleMethods.poppins20BoldMethod(
                context: context, text: team?.name ?? 'Team Name'),
          ),
          Center(
            child: Text(
              team?.about ?? 'No description available',
              style: AppTextStyles.poppins14Regular(context),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: PrimaryCTAButton(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.editTeamProfile);
              },
              label: 'Edit Profile',
            ),
          ),
          // rating
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    Iconsax.star1,
                    color: index < (team?.averageRating ?? 0).floor()
                        ? Colors.yellow
                        : Colors.grey,
                  ),
                ),
                4.width,
                ReusableTextStyleMethods.poppins14RegularMethod(
                    context: context, text: '${team?.averageRating ?? 0}'),
                ReusableTextStyleMethods.poppins12RegularMethod(
                    context: context,
                    text: '(${team?.ratingCount ?? 0} reviews)'),
              ],
            ),
          ),
          16.height,
        ],
      );
    });
  }

  // Helper method to build placeholder widget
  Widget _buildPlaceholder() {
    return Container(
      width: 126.w,
      height: 126.h,
      color: Colors.grey[300],
      child: Icon(
        Icons.business,
        size: 50.w,
        color: Colors.grey[600],
      ),
    );
  }

  void _showImageSourceOptions(BuildContext context) {
    final cubit = context.read<TeamProfileCubit>();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (BuildContext modalContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Image Source',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      modalContext,
                      icon: Icons.camera_alt,
                      title: 'Camera',
                      onTap: () {
                        Navigator.pop(modalContext);
                        _pickImage(ImageSource.camera, cubit);
                      },
                    ),
                    _buildImageSourceOption(
                      modalContext,
                      icon: Icons.photo_library,
                      title: 'Gallery',
                      onTap: () {
                        Navigator.pop(modalContext);
                        _pickImage(ImageSource.gallery, cubit);
                      },
                    ),
                  ],
                ),
                24.height,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 30.w,
            ),
          ),
          8.height,
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage(ImageSource source, TeamProfileCubit cubit) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null && mounted) {
        // Update local state first to show the selected image immediately
        setState(() {
          _selectedImagePath = pickedFile.path;
          _isUpdatingLogo = true;
        });

        // Then update the server
        cubit.updateTeamLogo(pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUpdatingLogo = false;
        });

        showAppSnackBar(
          context,
          message: 'Failed to pick image: $e',
          type: SnackBarType.error,
        );
      }
    }
  }
}

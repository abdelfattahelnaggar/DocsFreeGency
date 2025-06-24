import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/view_models/cubits/post_project_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class UploadProjectImages extends StatelessWidget {
  const UploadProjectImages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostProjectCubit, PostProjectState>(
      builder: (context, state) {
        final cubit = context.read<PostProjectCubit>();
        final images = cubit.pickedImages;

        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.01),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (images != null && images.isNotEmpty) ...[
                Text(
                  'Selected Images (${images.length})',
                  style: AppTextStyles.poppins16Regular(context)!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                16.h.height,
                SizedBox(
                  height: 120.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return Container(
                        width: 120.w,
                        margin: EdgeInsets.only(right: 8.w),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.file(
                                image,
                                height: 120.h,
                                width: 120.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => cubit.removeImage(index),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                16.h.height,
                Row(
                  children: [
                    Expanded(
                      child: PrimaryCTAButton(
                        label: 'Add More',
                        onTap: cubit.chooseImagesFromDevice,
                      ),
                    ),
                    8.w.width,
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => cubit.clearImages(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Clear All',
                          style:
                              AppTextStyles.poppins14Regular(context)!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/Pick a file.svg',
                        height: 100.h,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      16.h.height,
                      Text(
                        'Upload Multiple Project Images',
                        style:
                            AppTextStyles.poppins16Regular(context)!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      8.h.height,
                      Text(
                        'Select multiple images at once (JPG, PNG, GIF, WebP)',
                        style: AppTextStyles.poppins12Regular(context),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      24.h.height,
                      PrimaryCTAButton(
                        label: 'Choose Multiple Images',
                        onTap: cubit.chooseImagesFromDevice,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

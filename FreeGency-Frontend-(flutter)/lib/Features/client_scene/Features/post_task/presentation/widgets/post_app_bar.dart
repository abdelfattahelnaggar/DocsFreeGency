import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class PostAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const PostAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: ReusableTextStyleMethods.poppins20BoldMethod(
          context: context, text: context.tr(title)),
      automaticallyImplyLeading: false,
      elevation: 0,
      forceMaterialTransparency: false,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      actions: [
        IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.h, right: 8.w, left: 8.w),
          child: Text(
            textAlign: TextAlign.center,
            title == 'post_new_task'
                ? context.tr('post_task_description')
                : context.tr('post_job_description'),
            style: AppTextStyles.poppins14Regular(context),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(AppBar().preferredSize.height + 100.h);
}

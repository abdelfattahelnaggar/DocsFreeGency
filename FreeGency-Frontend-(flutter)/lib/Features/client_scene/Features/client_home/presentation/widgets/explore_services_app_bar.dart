import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class ExploreServicesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isDropdownOpen;
  final String selectedText;
  final VoidCallback onTitleTap;

  const ExploreServicesAppBar({
    super.key,
    required this.isDropdownOpen,
    required this.selectedText,
    required this.onTitleTap,
    required this.categoryName,
  });

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: false,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: !isDropdownOpen,
      leading: isDropdownOpen
          ? null
          : IconButton(
              icon: Icon(Iconsax.arrow_left_2,
                  color: Theme.of(context).colorScheme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
      title: GestureDetector(
        onTap: onTitleTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableTextStyleMethods.poppins20BoldMethod(
                  context: context,
                  text: categoryName,
                ),
                const SizedBox(width: 4),
                Icon(
                  isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
              ],
            ),
            Text(
              selectedText.isEmpty ? 'All Services' : selectedText,
              style: AppTextStyles.poppins16Regular(context)!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

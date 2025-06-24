import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class CustomTabBarForJobs extends StatelessWidget {
  const CustomTabBarForJobs({
    super.key,
    required this.icons,
    required TabController tabController,
    required this.labels,
  }) : _tabController = tabController;

  final List<IconData> icons;
  final TabController _tabController;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(icons.length, (index) {
          final isSelected = _tabController.index == index;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _tabController.animateTo(index),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[index],
                    size: 16,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    Text(
                      labels[index],
                      style: AppTextStyles.poppins12Regular(context)!
                          .copyWith(color: colorScheme.primary),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

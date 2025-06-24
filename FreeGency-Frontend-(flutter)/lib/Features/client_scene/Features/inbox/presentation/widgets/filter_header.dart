import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/view_model/cubit/notifications_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';

class FilterHeader extends StatelessWidget {
  final NotificationsCubit cubit;
  const FilterHeader({super.key, required this.cubit});

  String _getFilterValue(String displayText) {
    switch (displayText) {
      case 'All':
        return 'All';
      case 'Unread':
        return 'unRead';
      case 'Read':
        return 'read';
      default:
        return displayText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => cubit.toggleDropdown(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableTextStyleMethods.poppins16RegularMethod(
                      context: context,
                      text: cubit.selectedFilter[0].toUpperCase() +
                          cubit.selectedFilter.substring(1)),
                  Icon(
                    cubit.isDropdownOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          if (cubit.isDropdownOpen)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cubit.filters.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                itemBuilder: (context, index) {
                  final filter = cubit.filters[index];
                  return InkWell(
                    onTap: () => cubit.setFilter(_getFilterValue(filter)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: filter == cubit.selectedFilter
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: filter == cubit.selectedFilter
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).drawerTheme.backgroundColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

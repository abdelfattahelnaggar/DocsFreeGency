import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/home/presentation/view_model/cubits/change_btn_nav_bar/change_btn_nav_bar_cubit.dart';
import 'package:freegency_gp/core/utils/services/nav_bar_items_services.dart';

class CustomBtnNavBar extends StatelessWidget {
  const CustomBtnNavBar({
    super.key,
    required this.cubit,
    required this.role,
    required this.isTeamLeader,
    required this.isTeamMember,
    required this.isGuest,
  });

  final ChangeBtnNavBarCubit cubit;
  final bool role;
  final bool isTeamLeader;
  final bool isTeamMember;
  final bool isGuest;

  List<BottomNavigationBarItem> _getNavItems(BuildContext context) {
    if (role) {
      // Client navigation items
      return NavBarItemsServices.getClientItems(context, cubit);
    } else if (isTeamLeader) {
      // Team Leader navigation items
      return NavBarItemsServices.getTeamLeaderItems(context, cubit);
    } else if (isTeamMember) {
      // Team Member navigation items
      return NavBarItemsServices.getTeamMemberItems(context, cubit);
    } else {
      // Guest navigation items
      return NavBarItemsServices.getGuestItems(context, cubit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: BottomNavigationBar(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        items: _getNavItems(context),
        currentIndex: cubit.currentIndex,
        onTap: (index) => cubit.changeCurrentIndex(index),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NavBarItemsServices {
  static List<BottomNavigationBarItem> getClientItems(
      BuildContext context, final cubit) {
    return [
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 0
            ? const Icon(Iconsax.home_15)
            : const Icon(Iconsax.home),
        label: context.tr('home'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 1
            ? const Icon(Iconsax.direct5)
            : const Icon(Iconsax.direct),
        label: context.tr('notifications'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 2
            ? const Icon(Iconsax.user)
            : const Icon(Iconsax.user),
        label: context.tr('profile'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 3
            ? const Icon(Iconsax.briefcase1)
            : const Icon(Iconsax.briefcase),
        label: context.tr('jobs'),
      ),
    ];
  }

  static List<BottomNavigationBarItem> getTeamLeaderItems(
      BuildContext context, final cubit) {
    return [
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 0
            ? const Icon(Iconsax.home_15)
            : const Icon(Iconsax.home),
        label: context.tr('home'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 1
            ? const Icon(Iconsax.direct5)
            : const Icon(Iconsax.direct),
        label: context.tr('notifications'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 2
            ? const Icon(Iconsax.user)
            : const Icon(Iconsax.user),
        label: context.tr('profile'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 3
            ? const Icon(Iconsax.task_square)
            : const Icon(Iconsax.task_square),
        label: context.tr('Managment'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 4
            ? const Icon(Iconsax.briefcase1)
            : const Icon(Iconsax.briefcase),
        label: context.tr('jobs'),
      ),
    ];
  }

  static List<BottomNavigationBarItem> getTeamMemberItems(
      BuildContext context, final cubit) {
    return [
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 0
            ? const Icon(Iconsax.home_15)
            : const Icon(Iconsax.home),
        label: context.tr('home'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 1
            ? const Icon(Iconsax.direct5)
            : const Icon(Iconsax.direct),
        label: context.tr('notifications'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 2
            ? const Icon(Iconsax.user)
            : const Icon(Iconsax.user),
        label: context.tr('profile'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 3
            ? const Icon(Iconsax.task_square)
            : const Icon(Iconsax.task_square),
        label: context.tr('Managment'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 4
            ? const Icon(Iconsax.briefcase1)
            : const Icon(Iconsax.briefcase),
        label: context.tr('jobs'),
      ),
    ];
  }

  static List<BottomNavigationBarItem> getGuestItems(
      BuildContext context, final cubit) {
    return [
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 0
            ? const Icon(Iconsax.home_15)
            : const Icon(Iconsax.home),
        label: context.tr('home'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 1
            ? const Icon(Iconsax.user)
            : const Icon(Iconsax.user),
        label: context.tr('profile'),
      ),
      BottomNavigationBarItem(
        icon: cubit.currentIndex == 2
            ? const Icon(Iconsax.briefcase1)
            : const Icon(Iconsax.briefcase),
        label: context.tr('jobs'),
      ),
    ];
  }
}

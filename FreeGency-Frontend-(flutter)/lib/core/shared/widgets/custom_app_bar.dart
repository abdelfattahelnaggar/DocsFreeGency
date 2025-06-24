import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.child,
    this.isHome = true,
  });

  final Widget child;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: child,
      forceMaterialTransparency: false,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leading: isHome
          ? Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(
                    Iconsax.menu4,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            )
          : IconButton(
              icon: Icon(
                Iconsax.arrow_left_2,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
      actions: isHome
          ? [
              IconButton(
                onPressed: () {
                  // Go To Chat
                },
                icon: Icon(
                  Iconsax.messages_2,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}

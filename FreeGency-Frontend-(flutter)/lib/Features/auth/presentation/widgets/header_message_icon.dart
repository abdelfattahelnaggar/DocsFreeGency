import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HeaderMessageIcon extends StatelessWidget {
  const HeaderMessageIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 0.5,
                color: Theme.of(context).colorScheme.secondary,
              ),

              // color: Theme.of(context).colorScheme.secondary,
            ),
            child: const Icon(Iconsax.arrow_left_2),
          ),
        ),
      ],
    );
  }
}

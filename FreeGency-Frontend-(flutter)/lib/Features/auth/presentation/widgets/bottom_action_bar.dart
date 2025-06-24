import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';

class BottomActionBar extends StatelessWidget {
  final VoidCallback? onDonePressed;

  const BottomActionBar({
    super.key,
    required this.onDonePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: onDonePressed == null
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: onDonePressed,
            child: ReusableTextStyleMethods.poppins16BoldMethod(
              context: context,
              text: 'Done',
            ),
          ),
        ),
      ),
    );
  }
}

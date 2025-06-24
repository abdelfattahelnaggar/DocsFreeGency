import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatButtonWidget extends StatelessWidget {
  const ChatButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      child: Center(
        child: Icon(
          Iconsax.message_text,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

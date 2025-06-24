import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';

class InterestItem extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback? onTap;

  const InterestItem({
    super.key,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 2)
                : null,
          ),
          child: ListTile(
            leading: Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: ReusableTextStyleMethods.poppins16BoldMethod(
                context: context,
                text: title,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
              child: Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

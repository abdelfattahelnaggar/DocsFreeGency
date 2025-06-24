import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class PrimaryCTAButton extends StatelessWidget {
  const PrimaryCTAButton({
    super.key,
    this.label = 'Next',
    this.onTap,
    this.icon,
    this.child,
    this.color,
    this.labelColor,
    this.isLoading = false,
  });

  final String? label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Widget? child;
  final Color? color;
  final Color? labelColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 0,
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        textStyle: const TextStyle(
          fontSize: 14,
        ),
        minimumSize: const Size(double.infinity, 60),
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: labelColor ?? Colors.white, size: 20),
            const SizedBox(width: 8),
          ],
          if (child != null) ...[
            child!,
            const SizedBox(width: 8),
          ],
          Text(
            label!,
            style: AppTextStyles.poppins14Regular(context)!.copyWith(
              color: labelColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

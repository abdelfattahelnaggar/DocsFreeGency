import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class UsersCommentsItem extends StatelessWidget {
  const UsersCommentsItem({
    super.key,
    required this.comment,
  });

  final Map<String, dynamic> comment;

  @override
  Widget build(BuildContext context) {
    final int? rating = comment['rating'];

    return Stack(
      children: [
        ClipPath(
          clipper: HeartNotchClipper(),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar
                    comment['publisherImage'] != ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              comment['publisherImage'],
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment['clientName'] ?? '',
                              style: AppTextStyles.poppins12Regular(context)!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                          if (rating != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Iconsax.star1,
                                  size: 12,
                                  color: index < rating
                                      ? Colors.amber
                                      : Colors.grey.withValues(alpha: 0.3),
                                );
                              }),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(comment['postedAt'] ?? '',
                        style: AppTextStyles.poppins12Regular(context)!
                            .copyWith(fontSize: 8)),
                  ],
                ),
                const SizedBox(height: 16),
                ReusableTextStyleMethods.poppins24BoldMethod(
                    context: context, text: comment['comment'] ?? '')
              ],
            ),
          ),
        ),
        const Positioned(
          bottom: 12,
          right: 12,
          child: Icon(Iconsax.heart, color: Colors.white24, size: 20),
        )
      ],
    );
  }
}

class HeartNotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double borderRadius = 20;
    const double notchRadius = 20;

    final path = Path();

    // Start from top-left
    path.moveTo(0, borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0);

    // Top-right
    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    // Down right side
    path.lineTo(size.width, size.height - notchRadius * 2);

    // Curve inward for heart notch (bottom-right inward cut)
    path.arcToPoint(
      Offset(size.width - notchRadius * 2, size.height),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    // Bottom-left
    path.lineTo(borderRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - borderRadius);

    // Close path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

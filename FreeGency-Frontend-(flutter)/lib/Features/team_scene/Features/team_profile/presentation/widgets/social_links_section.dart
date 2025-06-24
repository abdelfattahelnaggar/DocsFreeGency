import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/view_model/cubit/team_profile_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinksSection extends StatelessWidget {
  const SocialLinksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamProfileCubit, TeamProfileState>(
      builder: (context, state) {
        final cubit = context.read<TeamProfileCubit>();
        final socialLinks = cubit.myTeam?.socialMediaLinks ?? [];

        if (socialLinks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            ReusableTextStyleMethods.poppins16BoldMethod(
                context: context, text: 'Social Media'),
            12.height,
            Wrap(
              spacing: 20.w,
              runSpacing: 16.h,
              children: socialLinks.map((link) {
                return _buildSocialLinkItem(
                  context,
                  link['platform'] ?? '',
                  link['url'] ?? '',
                );
              }).toList(),
            ),
            16.height,
          ],
        );
      },
    );
  }

  Widget _buildSocialLinkItem(
      BuildContext context, String platform, String url) {
    IconData fallbackIcon;
    Color color;
    String displayName = platform;

    // Extract website name from URL if platform is "website"
    if (platform.toLowerCase() == 'website') {
      displayName = _extractWebsiteName(url);
    }

    // Set icon and color based on platform
    switch (platform.toLowerCase()) {
      case 'facebook':
        fallbackIcon = Icons.facebook;
        color = const Color(0xFF1877F2);
        break;
      case 'twitter':
      case 'x':
        fallbackIcon = Iconsax.message;
        color = const Color(0xFF1DA1F2);
        break;
      case 'instagram':
        fallbackIcon = Iconsax.instagram;
        color = const Color(0xFFE4405F);
        break;
      case 'linkedin':
        fallbackIcon = Iconsax.link;
        color = const Color(0xFF0A66C2);
        break;
      case 'github':
        fallbackIcon = Icons.code;
        color = const Color(0xFF171515);
        break;
      case 'behance':
        fallbackIcon = Icons.brush;
        color = const Color(0xFF053EFF);
        break;
      case 'dribbble':
        fallbackIcon = Icons.sports_basketball;
        color = const Color(0xFFEA4C89);
        break;
      case 'website':
        fallbackIcon = Icons.language;
        color = const Color(0xFF0078D4);
        break;
      default:
        fallbackIcon = Icons.link;
        color = Colors.grey;
    }

    return InkWell(
      onTap: () async {
        // Open in external browser
        final Uri uri = Uri.parse(url);
        try {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          log('Error launching URL: $e');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Center(
              child: _buildSocialIcon(
                  context, platform.toLowerCase(), color, fallbackIcon),
            ),
          ),
          8.height,
          Text(
            displayName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _extractWebsiteName(String url) {
    try {
      // Remove protocol
      String cleanUrl = url.replaceFirst(RegExp(r'https?://'), '');

      // Remove www. if present
      cleanUrl = cleanUrl.replaceFirst('www.', '');

      // Get domain part (before first slash)
      final domainParts = cleanUrl.split('/');
      String domain = domainParts[0];

      // Get the main domain name (e.g. "linkedin" from "linkedin.com")
      final parts = domain.split('.');
      if (parts.length > 1) {
        return parts[parts.length - 2].capitalize();
      }

      return domain.capitalize();
    } catch (e) {
      log('Error extracting website name: $e');
      return 'Website';
    }
  }

  Widget _buildSocialIcon(BuildContext context, String platform, Color color,
      IconData fallbackIcon) {
    String iconPath = 'assets/icons/$platform.svg';

    try {
      return SvgPicture.asset(
        iconPath,
        width: 24.w,
        height: 24.w,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } catch (e) {
      log('Failed to load SVG icon: $e');
      return Icon(fallbackIcon, color: color, size: 24.w);
    }
  }
}

// Extension to capitalize first letter of string
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

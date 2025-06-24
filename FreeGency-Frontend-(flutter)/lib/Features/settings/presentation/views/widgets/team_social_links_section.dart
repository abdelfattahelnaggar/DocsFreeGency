import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/settings/presentation/cubit/team_profile_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';

import 'section_card_widget.dart';
import 'team_social_link_field_widget.dart';

class TeamSocialLinksSection extends StatelessWidget {
  final List<dynamic> socialLinks;
  final Map<String, TextEditingController> socialLinkControllers;
  final VoidCallback onAddSocialLink;

  const TeamSocialLinksSection({
    super.key,
    required this.socialLinks,
    required this.socialLinkControllers,
    required this.onAddSocialLink,
  });

  @override
  Widget build(BuildContext context) {
    // Debug print to check if socialLinks are empty or not
    print('Social Links in TeamSocialLinksSection: $socialLinks');

    return SectionCardWidget(
      title: context.tr('edit_profile.social_links'),
      children: [
        if (socialLinks.isEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              context.tr('edit_profile.no_social_links'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        if (socialLinks.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: socialLinks.length,
            itemBuilder: (context, index) {
              final link = socialLinks[index] as Map<String, dynamic>;
              final linkId = link['id'] as String? ??
                  DateTime.now().millisecondsSinceEpoch.toString() +
                      index.toString();

              // Ensure the link has an ID
              if (link['id'] == null) {
                link['id'] = linkId;
                // Update the link in the cubit
                context.read<TeamProfileCubit>().updateSocialLink(
                    linkId, link['platform'] ?? 'Website', link['url'] ?? '');
              }

              // Get existing controller or create a new one
              final controller = socialLinkControllers.putIfAbsent(
                linkId,
                () => TextEditingController(text: link['url'] as String? ?? ''),
              );

              return TeamSocialLinkFieldWidget(
                key: ValueKey('team_social_link_$linkId'),
                link: link,
                controller: controller,
              );
            },
            separatorBuilder: (context, index) => 16.height,
          ),
        16.height,
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          width: double.infinity,
          child: TextButton.icon(
            icon: const Icon(Iconsax.add),
            label: ReusableTextStyleMethods.poppins14RegularMethod(
                context: context, text: context.tr('edit_profile.add_link')),
            onPressed: onAddSocialLink,
          ),
        ),
      ],
    );
  }
}

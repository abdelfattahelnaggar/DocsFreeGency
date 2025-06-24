import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:iconsax/iconsax.dart';

import '../../cubit/team_profile_cubit.dart';

class TeamSocialLinkFieldWidget extends StatefulWidget {
  final Map<String, dynamic> link;
  final TextEditingController controller;

  const TeamSocialLinkFieldWidget({
    super.key,
    required this.link,
    required this.controller,
  });

  @override
  State<TeamSocialLinkFieldWidget> createState() =>
      _TeamSocialLinkFieldWidgetState();
}

class _TeamSocialLinkFieldWidgetState extends State<TeamSocialLinkFieldWidget> {
  late String selectedPlatform;

  @override
  void initState() {
    super.initState();
    selectedPlatform = normalizePlatformValue(widget.link['platform']);
  }

  @override
  void didUpdateWidget(TeamSocialLinkFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.link['platform'] != widget.link['platform']) {
      setState(() {
        selectedPlatform = normalizePlatformValue(widget.link['platform']);
      });
    }
  }

  String normalizePlatformValue(String? value) {
    if (value == null) return 'Website';
    if (value == 'GitHub') return 'Github';
    if (value == 'LinkedIn') return 'Linkedin';
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final platforms = ['Website', 'Linkedin', 'Github', 'Facebook', 'Other'];

    IconData getIconForPlatform(String platform) {
      switch (platform) {
        case 'Linkedin':
          return Iconsax.link;
        case 'Github':
          return Iconsax.code;
        case 'Facebook':
          return Iconsax.profile_2user;
        case 'Other':
          return Iconsax.link_21;
        default:
          return Iconsax.global;
      }
    }

    String getPlatformTranslation(String platform) {
      switch (platform.toLowerCase()) {
        case 'website':
          return context.tr('platforms.website');
        case 'linkedin':
          return context.tr('platforms.linkedin');
        case 'github':
          return context.tr('platforms.github');
        case 'facebook':
          return context.tr('platforms.facebook');
        case 'other':
          return context.tr('platforms.other');
        default:
          return platform;
      }
    }

    return Row(
      children: [
        IconButton(
          icon: const Icon(Iconsax.trash, color: Colors.redAccent),
          onPressed: () => context
              .read<TeamProfileCubit>()
              .removeSocialLink(widget.link['id']),
        ),
        Expanded(
          child: CustomTextField(
            fillColor: Theme.of(context).colorScheme.surface,
            controller: widget.controller,
            hintText: context.tr('edit_profile.enter_url_hint'),
            prefixIcon: getIconForPlatform(selectedPlatform),
            onChanged: (value) {
              context
                  .read<TeamProfileCubit>()
                  .updateSocialLink(widget.link['id'], selectedPlatform, value);
            },
          ),
        ),
        16.width,
        DropdownButton<String>(
          value: selectedPlatform,
          underline: const SizedBox.shrink(),
          items: platforms.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: ReusableTextStyleMethods.poppins14RegularMethod(
                  context: context, text: getPlatformTranslation(value)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedPlatform = newValue;
              });
              context.read<TeamProfileCubit>().updateSocialLink(
                  widget.link['id'], newValue, widget.controller.text);
            }
          },
        ),
      ],
    );
  }
}

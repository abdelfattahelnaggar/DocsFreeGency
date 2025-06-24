import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreviewWidget extends StatelessWidget {
  final String url;

  const LinkPreviewWidget({super.key, required this.url});

  IconData _getIconForLink(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return Iconsax.link;

    final host = uri.host.toLowerCase();
    if (host.contains('drive.google.com')) return Iconsax.document_upload;
    if (host.contains('github.com')) return Iconsax.code;
    if (host.contains('figma.com')) return Iconsax.pen_tool;
    if (host.contains('trello.com')) return Iconsax.fatrows;
    if (host.contains('slack.com')) return Iconsax.message;
    if (host.contains('youtube.com') || host.contains('youtu.be')) {
      return Iconsax.video_play;
    }
    return Iconsax.link;
  }

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // Could show a snackbar here if needed
      log('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchUrl,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              _getIconForLink(url),
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                url,
                style: AppTextStyles.poppins12Regular(context)!.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

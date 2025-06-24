import 'package:flutter/material.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/link_preview_widget.dart';
import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/presentation/widgets/user_avatar.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

/// Enhanced CommentWidget with special alignment for assigned sub task members
///
/// Features:
/// - Regular comments: Left-aligned with standard styling
/// - Assigned member comments: Right-aligned with special styling
/// - Visual indicators: Badge showing "Assignee" for the assigned member
/// - Distinctive colors: Primary color theme for assigned member comments
class CommentWidget extends StatelessWidget {
  final Map<String, dynamic> comment;
  final String teamName;
  final String? assignedMemberId; // ID of the member assigned to this sub task

  const CommentWidget({
    super.key,
    required this.comment,
    required this.teamName,
    this.assignedMemberId,
  });

  (String, String?, String) _extractUrlAndText(String text) {
    try {
      final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)');
      final match = urlRegExp.firstMatch(text);
      if (match != null) {
        final url = match.group(0)!;
        final startIndex = match.start;
        final endIndex = match.end;

        final before = text.substring(0, startIndex).trim();
        final after = text.substring(endIndex).trim();

        return (before, url, after);
      }
      return (text.trim(), null, '');
    } catch (e) {
      return (text.trim(), null, '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReply = comment['role'] == 1;
    final displayName = isReply ? comment['name'] : teamName;
    final imageUrl = comment['imageUrl'];
    final commentText = comment['comment'] ?? '';
    final status = isReply ? "Reply" : "Comment";
    final commenterId =
        comment['userId']; // Assuming we have userId in comment data

    // Check if this comment is from the assigned member
    final isAssignedMember = assignedMemberId != null &&
        commenterId != null &&
        commenterId == assignedMemberId;

    final (textBefore, extractedUrl, textAfter) =
        _extractUrlAndText(commentText);

    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
        // Different alignment for assigned member vs others
        left: isAssignedMember ? 32.0 : (isReply ? 24.0 : 0.0),
        right: isAssignedMember ? 0.0 : 12.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Reverse direction for assigned member to align them to the right
        textDirection: isAssignedMember ? TextDirection.rtl : TextDirection.ltr,
        children: [
          UserAvatar(name: displayName, imageUrl: imageUrl),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // Different background color for assigned member
                color: isAssignedMember
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isAssignedMember ? 16 : 4),
                  topRight: Radius.circular(isAssignedMember ? 4 : 16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
                border: isAssignedMember
                    ? Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: isAssignedMember
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: isAssignedMember
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (isAssignedMember) ...[
                        // Show status first for assigned member
                        Text(
                          status,
                          style:
                              AppTextStyles.poppins12Regular(context)!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          displayName,
                          style:
                              AppTextStyles.poppins14Regular(context)!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isAssignedMember
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isAssignedMember) ...[
                        const SizedBox(width: 8),
                        Text(
                          status,
                          style:
                              AppTextStyles.poppins12Regular(context)!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                      if (isAssignedMember)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Assignee',
                            style: AppTextStyles.poppins12Regular(context)!
                                .copyWith(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (textBefore.isNotEmpty)
                    Text(
                      textBefore,
                      style: AppTextStyles.poppins12Regular(context)!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign:
                          isAssignedMember ? TextAlign.right : TextAlign.left,
                      softWrap: true,
                    ),
                  if (extractedUrl != null) ...[
                    if (textBefore.isNotEmpty) const SizedBox(height: 8),
                    LinkPreviewWidget(url: extractedUrl),
                  ],
                  if (textAfter.isNotEmpty) ...[
                    if (extractedUrl != null) const SizedBox(height: 8),
                    Text(
                      textAfter,
                      style: AppTextStyles.poppins12Regular(context)!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign:
                          isAssignedMember ? TextAlign.right : TextAlign.left,
                      softWrap: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

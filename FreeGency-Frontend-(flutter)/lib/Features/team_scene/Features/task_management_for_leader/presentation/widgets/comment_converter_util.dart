import 'package:freegency_gp/Features/team_scene/Features/task_management_for_leader/data/model/sub_task_model.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Utility class for converting Comment objects to UI-compatible format
///
/// Enhanced to support assigned member detection by including userId in the converted data
class CommentConverterUtil {
  /// Converts Comment objects to Map format required by UI
  ///
  /// The converted format includes:
  /// - role: User role (0 = team leader/current user, 1 = team member)
  /// - name: Commenter's name
  /// - imageUrl: Profile image URL
  /// - comment: Comment text
  /// - status: Relative time (e.g., "2 hours ago")
  /// - userId: Unique identifier for detecting assigned member comments
  static Future<List<Map<String, dynamic>>> convertCommentsToMapAsync(
    List<Comment> comments,
  ) async {
    // Get current user ID for role determination
    final currentUser = await LocalStorage.getUserData();
    final currentUserId = currentUser?.id;

    return comments.map((comment) {
      // Use timeago for relative time formatting
      String timeAgo = 'now';
      try {
        // If comment has timestamp, use it. Otherwise default to 'now'
        // For now using a mock relative time, in real implementation
        // you would use actual comment timestamp
        timeAgo =
            timeago.format(DateTime.now().subtract(const Duration(minutes: 1)));
      } catch (e) {
        timeAgo = 'now';
      }

      // Determine role based on whether this is the current user
      int role = 1; // Default to team member
      if (currentUserId != null && comment.user.id == currentUserId) {
        role = 0; // Current user/Team leader
      }

      return {
        "role": role,
        "name": comment.user.name,
        "imageUrl": comment.user.profileImage,
        "comment": comment.text,
        "status": timeAgo,
        "userId": comment.user.id,
      };
    }).toList();
  }

  /// Converts Comment objects to Map format required by UI (synchronous version)
  ///
  /// This version uses the provided currentUserId parameter for role determination
  static List<Map<String, dynamic>> convertCommentsToMap(
    List<Comment> comments, {
    String? currentUserId,
  }) {
    return comments.map((comment) {
      // Use timeago for relative time formatting
      String timeAgo = 'now';
      try {
        // If comment has timestamp, use it. Otherwise default to 'now'
        // For now using a mock relative time, in real implementation
        // you would use actual comment timestamp
        timeAgo =
            timeago.format(DateTime.now().subtract(const Duration(minutes: 1)));
      } catch (e) {
        timeAgo = 'now';
      }

      // Determine role based on user type
      int role = 1; // Default to team member
      if (currentUserId != null && comment.user.id == currentUserId) {
        role = 0; // Current user/Team leader
      }

      return {
        "role": role,
        "name": comment.user.name,
        "imageUrl": comment.user.profileImage,
        "comment": comment.text,
        "status": timeAgo,
        "userId": comment.user.id,
      };
    }).toList();
  }

  /// Adds a new comment to existing comments list
  static List<Map<String, dynamic>> addNewComment(
    List<Map<String, dynamic>> existingComments,
    String comment,
    String userName, {
    String? userImageUrl,
    String? userId,
    int role = 0, // Default to team leader
  }) {
    final newComment = {
      "role": role,
      "name": userName,
      "imageUrl": userImageUrl,
      "comment": comment,
      "status": "now",
      "userId": userId,
    };

    return [...existingComments, newComment];
  }
}

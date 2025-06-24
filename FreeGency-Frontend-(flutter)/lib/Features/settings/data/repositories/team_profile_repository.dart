import '../models/edit_team_profile_request_model.dart';
import '../models/edit_team_profile_response_model.dart';

abstract class TeamProfileRepository {
  /// Load the current team profile
  Future<TeamData> loadTeamProfile();

  /// Update team profile with new data
  Future<EditTeamProfileResponseModel> updateTeamProfile(
      EditTeamProfileRequestModel request);

  /// Update team logo
  Future<String> updateTeamLogo(String imagePath);

  /// Change team password
  Future<void> changePassword(String currentPassword, String newPassword);

  /// Navigate to manage team members
  Future<void> navigateToManageTeamMembers();

  /// Navigate to payment methods
  Future<void> navigateToPaymentMethods();
}

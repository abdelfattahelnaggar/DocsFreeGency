import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/repositories/implement_team_profile_repo.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/repositories/team_profile_repo.dart';

import 'team_profile_state.dart';

class TeamProfileCubit extends Cubit<TeamProfileState> {
  final TeamProfileRepo _repository;
  TeamsModel? _inMemoryProfile;

  TeamsModel? get inMemoryProfile => _inMemoryProfile;

  TeamProfileCubit({TeamProfileRepo? repository})
      : _repository = repository ?? TeamProfileRepoImplementation(),
        super(TeamProfileInitial());

  Future<void> loadTeamProfile() async {
    emit(TeamProfileLoading());
    try {
      final result = await _repository.getMyTeamProfile();
      result.fold(
        (failure) => emit(TeamProfileError(message: failure.errorMessage)),
        (teamProfile) {
          _inMemoryProfile = teamProfile.copyWith(
              socialMediaLinks: teamProfile.socialMediaLinks ?? []);
          emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
        },
      );
    } catch (e) {
      emit(TeamProfileError(message: e.toString()));
    }
  }

  void addSkill(String skill) {
    if (_inMemoryProfile == null || skill.trim().isEmpty) return;
    final currentSkills = List<String>.from(_inMemoryProfile!.skills ?? []);
    if (!currentSkills.contains(skill.trim())) {
      _inMemoryProfile =
          _inMemoryProfile!.copyWith(skills: [...currentSkills, skill.trim()]);
      emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
    }
  }

  void removeSkill(String skill) {
    if (_inMemoryProfile == null) return;
    final updatedSkills = List<String>.from(_inMemoryProfile!.skills ?? [])
      ..remove(skill);
    _inMemoryProfile = _inMemoryProfile!.copyWith(skills: updatedSkills);
    emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
  }

  void addEmptySocialLink() {
    if (_inMemoryProfile == null) return;
    final currentLinks = List<Map<String, dynamic>>.from(
        _inMemoryProfile!.socialMediaLinks ?? []);
    final newLink = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'platform': 'Website',
      'url': '',
    };
    _inMemoryProfile = _inMemoryProfile!
        .copyWith(socialMediaLinks: [...currentLinks, newLink]);
    emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
  }

  void updateSocialLink(String id, String platform, String url) {
    if (_inMemoryProfile == null) return;
    final currentLinks = List<Map<String, dynamic>>.from(
        _inMemoryProfile!.socialMediaLinks ?? []);
    final linkIndex = currentLinks.indexWhere((link) => link['id'] == id);
    if (linkIndex != -1) {
      currentLinks[linkIndex] = {
        'id': id,
        'platform': platform,
        'url': url,
      };
      _inMemoryProfile =
          _inMemoryProfile!.copyWith(socialMediaLinks: currentLinks);
      // No emit here to prevent cursor jump, text controller handles UI update
    }
  }

  void removeSocialLink(String id) {
    if (_inMemoryProfile == null) return;

    // Create a new list to avoid modifying the original during iteration
    final currentLinks = List<Map<String, dynamic>>.from(
        _inMemoryProfile!.socialMediaLinks ?? []);

    // Find and remove only the link with the matching ID
    final linkToRemove = currentLinks.firstWhere(
      (link) => link['id'] == id,
      orElse: () => <String, dynamic>{},
    );

    if (linkToRemove.isNotEmpty) {
      currentLinks.remove(linkToRemove);
      _inMemoryProfile =
          _inMemoryProfile!.copyWith(socialMediaLinks: currentLinks);
      emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
    }
  }

  Future<void> saveTeamProfileChanges({
    required String teamName,
    required String description,
    String? email,
    String? phone,
    String? pricing,
  }) async {
    if (_inMemoryProfile == null) return;

    emit(TeamProfileUpdating());

    // Validate required fields
    if (teamName.trim().isEmpty) {
      emit(const TeamValidationError(
          field: 'name', message: 'Team name is required'));
      if (_inMemoryProfile != null) {
        emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
      }
      return;
    }

    // Update the in-memory profile
    Map<String, String> contactInfo = {};
    if (email?.isNotEmpty == true) contactInfo['email'] = email!;
    if (phone?.isNotEmpty == true) contactInfo['phone'] = phone!;

    _inMemoryProfile = _inMemoryProfile!.copyWith(
      name: teamName,
      about: description,
      contactInfo: contactInfo.isNotEmpty ? contactInfo : null,
    );

    try {
      // Convert social media links from array to object format for API
      Map<String, String> socialMediaLinksObject = {};

      if (_inMemoryProfile!.socialMediaLinks != null) {
        for (var link in _inMemoryProfile!.socialMediaLinks!) {
          final platform = link['platform'].toString().toLowerCase();
          final url = link['url'].toString();

          // Only add links with non-empty URLs
          if (url.isNotEmpty) {
            socialMediaLinksObject[platform] = url;
          }
        }
      }

      final updateData = {
        'name': _inMemoryProfile!.name,
        'aboutUs': _inMemoryProfile!.about,
        if (contactInfo.isNotEmpty) 'contactInfo': contactInfo,
        'skills': _inMemoryProfile!.skills,
        'socialMediaLinks':
            socialMediaLinksObject, // Send as object instead of array
      };

      // print('Sending update data: $updateData'); // Debug print

      final result = await _repository.updateTeamProfile(updateData);

      result.fold(
        (failure) {
          emit(TeamProfileError(message: failure.errorMessage));
          if (_inMemoryProfile != null) {
            emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
          }
        },
        (message) {
          emit(TeamProfileUpdated(message: message));
          loadTeamProfile();
        },
      );
    } catch (e) {
      emit(TeamProfileError(message: e.toString()));
      if (_inMemoryProfile != null) {
        emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
      }
    }
  }

  Future<void> updateTeamLogo(String imagePath) async {
    if (state is! TeamProfileLoaded) return;
    emit(TeamLogoUpdating());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(const TeamLogoUpdated(logoUrl: 'https://example.com/new-logo.jpg'));
      await loadTeamProfile();
    } catch (e) {
      emit(TeamProfileError(message: e.toString()));
      if (_inMemoryProfile != null) {
        emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
      }
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    if (_inMemoryProfile == null) return;
    emit(TeamPasswordChanging());
    try {
      // Validation logic here...
      await Future.delayed(const Duration(seconds: 1));
      emit(TeamPasswordChanged());
      emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
    } catch (e) {
      emit(TeamPasswordError(message: e.toString()));
      emit(TeamProfileLoaded(teamProfile: _inMemoryProfile!));
    }
  }

  Future<void> navigateToManageTeamMembers() async {}
  Future<void> navigateToPaymentMethods() async {}
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';

import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  // This will hold the profile data in memory
  Map<String, dynamic>? _inMemoryProfile;

  Map<String, dynamic>? get inMemoryProfile => _inMemoryProfile;

  Future<void> loadUserProfile() async {
    try {
      emit(UserProfileLoading());

      final userRole = await LocalStorage.getUserRole() ?? 'client';

      // TODO: Replace with actual API call to fetch the profile
      _inMemoryProfile = {
        'id': '1',
        'name': 'Mohamed Hassan',
        'email': 'user@example.com',
        'phone': '+20 123 456 7890',
        'bio': "I'm a passionate developer/client!",
        'profileImageUrl': 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
        'skills':
            userRole == 'teamMember' ? ['Flutter', 'Dart', 'Firebase'] : [],
        'socialLinks': [
          {
            'id': '1',
            'platform': 'Linkedin',
            'url': 'linkedin.com/in/user',
          },
        ],
        'role': userRole,
      };

      emit(UserProfileLoaded(
          userProfile: Map<String, dynamic>.from(_inMemoryProfile!)));
    } catch (e) {
      emit(UserProfileError(message: e.toString()));
    }
  }

  // This method only updates the local state, no API calls
  void updateLocalProfile({
    String? name,
    String? email,
    String? phone,
    String? bio,
  }) {
    if (_inMemoryProfile == null) return;

    _inMemoryProfile!['name'] = name ?? _inMemoryProfile!['name'];
    _inMemoryProfile!['email'] = email ?? _inMemoryProfile!['email'];
    _inMemoryProfile!['phone'] = phone ?? _inMemoryProfile!['phone'];
    _inMemoryProfile!['bio'] = bio ?? _inMemoryProfile!['bio'];

    // Emit loaded state to reflect changes instantly without a loading indicator
    emit(UserProfileLoaded(
        userProfile: Map<String, dynamic>.from(_inMemoryProfile!)));
  }

  void addSkill(String skill) {
    if (_inMemoryProfile == null || skill.trim().isEmpty) return;
    final currentSkills = List<String>.from(_inMemoryProfile!['skills'] ?? []);
    if (!currentSkills.contains(skill.trim())) {
      currentSkills.add(skill.trim());
      _inMemoryProfile!['skills'] = currentSkills;
      emit(UserProfileLoaded(
          userProfile: Map<String, dynamic>.from(_inMemoryProfile!)));
    }
  }

  void removeSkill(String skill) {
    if (_inMemoryProfile == null) return;
    final currentSkills = List<String>.from(_inMemoryProfile!['skills'] ?? []);
    currentSkills.remove(skill);
    _inMemoryProfile!['skills'] = currentSkills;
    emit(UserProfileLoaded(
        userProfile: Map<String, dynamic>.from(_inMemoryProfile!)));
  }

  void addEmptySocialLink() {
    if (_inMemoryProfile == null) return;
    final currentLinks =
        List<Map<String, dynamic>>.from(_inMemoryProfile!['socialLinks'] ?? []);
    final newLink = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
      'platform': 'Website',
      'url': '',
    };
    currentLinks.add(newLink);
    _inMemoryProfile!['socialLinks'] = currentLinks;
    emit(UserProfileLoaded(
        userProfile: Map<String, dynamic>.from(_inMemoryProfile!)));
  }

  void removeSocialLink(String linkId) {
    if (_inMemoryProfile == null) return;

    // Create a new list to avoid modifying the original during iteration
    final currentLinks =
        List<Map<String, dynamic>>.from(_inMemoryProfile!['socialLinks'] ?? []);

    // Find and remove only the link with the matching ID
    final linkToRemove = currentLinks.firstWhere(
      (link) => link['id'] == linkId,
      orElse: () => <String, dynamic>{},
    );

    if (linkToRemove.isNotEmpty) {
      currentLinks.remove(linkToRemove);
      _inMemoryProfile!['socialLinks'] = currentLinks;

      // Emit updated state to refresh the UI
      emit(UserProfileLoaded(
          userProfile: Map<String, dynamic>.from(_inMemoryProfile!)));
    }
  }

  void updateSocialLink(String linkId, String platform, String url) {
    if (_inMemoryProfile == null) return;
    final currentLinks =
        List<Map<String, dynamic>>.from(_inMemoryProfile!['socialLinks'] ?? []);
    final linkIndex = currentLinks.indexWhere((link) => link['id'] == linkId);
    if (linkIndex != -1) {
      currentLinks[linkIndex]['platform'] = platform;
      currentLinks[linkIndex]['url'] = url;
      _inMemoryProfile!['socialLinks'] = currentLinks;
    }
    // No emit here to avoid cursor jumping, page state handles controller
  }

  // The main save method that makes the API call
  Future<void> saveProfile({
    required String name,
    required String bio,
    required String phone,
    required String email,
  }) async {
    try {
      emit(UserProfileUpdating());

      // Validate fields
      if (name.trim().isEmpty) {
        emit(const ValidationError(
            field: 'name', message: 'Name cannot be empty'));
        _emitLoadedStateAfterError();
        return;
      }
      if (!_isValidEmail(email)) {
        emit(const ValidationError(
            field: 'email', message: 'Please enter a valid email'));
        _emitLoadedStateAfterError();
        return;
      }

      // Update the final data to be saved
      _inMemoryProfile!['name'] = name;
      _inMemoryProfile!['bio'] = bio;
      _inMemoryProfile!['phone'] = phone;
      _inMemoryProfile!['email'] = email;

      // TODO: Call API to update the entire profile with data from _inMemoryProfile
      print('Saving profile: $_inMemoryProfile');
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // On success, you might want to reload the profile from the server
      // or just confirm it's updated.
      emit(UserProfileUpdated(
          userProfile: Map<String, dynamic>.from(_inMemoryProfile!)));
      emit(UserProfileLoaded(
          userProfile: Map<String, dynamic>.from(_inMemoryProfile!)));
    } catch (e) {
      emit(UserProfileError(message: e.toString()));
      _emitLoadedStateAfterError();
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      if (_inMemoryProfile == null) return;

      emit(ProfileImageUpdating());

      // TODO: Upload image to server and get URL
      await Future.delayed(const Duration(seconds: 2)); // Simulate upload

      const newImageUrl = 'https://i.pravatar.cc/150?u=updated';

      _inMemoryProfile = Map<String, dynamic>.from(_inMemoryProfile!)
        ..['profileImageUrl'] = newImageUrl;

      emit(const ProfileImageUpdated(newImageUrl: newImageUrl));
      emit(UserProfileLoaded(
          userProfile: Map<String, dynamic>.from(_inMemoryProfile!)));
    } catch (e) {
      emit(UserProfileError(message: e.toString()));
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    try {
      emit(PasswordChanging());

      // Validate passwords
      if (currentPassword.isEmpty ||
          newPassword.isEmpty ||
          confirmPassword.isEmpty) {
        emit(const ValidationError(
            field: 'password', message: 'All password fields are required'));
        return;
      }

      if (newPassword != confirmPassword) {
        emit(const ValidationError(
            field: 'password', message: 'New passwords do not match'));
        return;
      }

      if (newPassword.length < 8) {
        emit(const ValidationError(
            field: 'password',
            message: 'Password must be at least 8 characters'));
        return;
      }

      // TODO: Call API to change password
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      emit(PasswordChanged());
    } catch (e) {
      emit(UserProfileError(message: e.toString()));
    }
  }

  void _emitLoadedStateAfterError() {
    if (_inMemoryProfile != null) {
      emit(UserProfileLoaded(
          userProfile: Map<String, dynamic>.from(_inMemoryProfile!)));
    } else {
      emit(UserProfileInitial());
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-()]+$').hasMatch(phone) && phone.length >= 10;
  }
}

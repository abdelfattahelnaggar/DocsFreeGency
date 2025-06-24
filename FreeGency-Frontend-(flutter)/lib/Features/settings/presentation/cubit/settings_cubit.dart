import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';
import 'package:freegency_gp/core/utils/localization/app_localization.dart';
import 'package:get/get.dart';

// import '../../data/models/settings_model.dart'; // TODO: Add your custom settings model
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  // SettingsModel? _currentSettings; // TODO: Replace with your custom settings model
  Map<String, dynamic>? _currentSettings; // Temporary placeholder

  Map<String, dynamic>? get currentSettings => _currentSettings;

  Future<void> loadSettings(BuildContext context) async {
    try {
      emit(SettingsLoading());

      final userRole = await LocalStorage.getUserRole() ?? 'client';
      final currentLanguage = AppLocalization.getCurrentLanguage(context);
      final isDarkMode = AdaptiveTheme.of(context).mode.isDark;

      _currentSettings = {
        'notificationsEnabled': true, // TODO: Get from preferences
        'currentLanguage': currentLanguage,
        'isDarkMode': isDarkMode,
        'userRole': userRole,
        'appVersion': '1.0.0',
      };

      emit(SettingsLoaded(settings: _currentSettings!));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> toggleNotifications(bool isEnabled) async {
    try {
      if (_currentSettings != null) {
        _currentSettings = Map<String, dynamic>.from(_currentSettings!)
          ..['notificationsEnabled'] = isEnabled;

        // TODO: Save to preferences
        emit(NotificationsToggled(isEnabled: isEnabled));
        emit(SettingsLoaded(settings: _currentSettings!));
      }
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> changeLanguage(BuildContext context, String newLanguage) async {
    try {
      if (_currentSettings != null) {
        AppLocalization.changeLanguage(context, newLanguage);

        _currentSettings = Map<String, dynamic>.from(_currentSettings!)
          ..['currentLanguage'] = newLanguage;

        emit(LanguageChanged(newLanguage: newLanguage));
        emit(SettingsLoaded(settings: _currentSettings!));
      }
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> toggleTheme(BuildContext context, bool isDarkMode) async {
    try {
      if (isDarkMode) {
        AdaptiveTheme.of(context).setDark();
      } else {
        AdaptiveTheme.of(context).setLight();
      }

      if (_currentSettings != null) {
        _currentSettings = Map<String, dynamic>.from(_currentSettings!)
          ..['isDarkMode'] = isDarkMode;

        emit(ThemeChanged(isDarkMode: isDarkMode));
        emit(SettingsLoaded(settings: _currentSettings!));
      }
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> navigateToProfileEdit() async {
    try {
      if (_currentSettings != null) {
        switch (_currentSettings!['userRole'] as String?) {
          case 'client':
            Get.toNamed(AppRoutes.editUserProfile);
            break;
          case 'teamLeader':
            Get.toNamed(AppRoutes.editTeamProfile);
            break;
          case 'teamMember':
            Get.toNamed(AppRoutes.editUserProfile);
            break;
          default:
            Get.toNamed(AppRoutes.editUserProfile);
        }
      }
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> navigateToEditInterests() async {
    Get.toNamed(AppRoutes.chooseInterests, arguments: {'editMode': true});
  }

  void navigateToHelpAndFeedback() {
    // TODO: Implement help and feedback navigation
  }

  void navigateToAboutApp() {
    // TODO: Implement about app navigation
  }

  void navigateToContactDevelopers() {
    // TODO: Implement contact developers navigation
  }

  Future<void> logout() async {
    try {
      // TODO: Implement logout logic
      // Clear user session, navigate to login
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    try {
      // TODO: Implement delete account logic
      // Show confirmation dialog, call API, clear data
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }
}

import 'package:equatable/equatable.dart';

// import '../../data/models/settings_model.dart'; // TODO: Add your custom settings model

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  // final SettingsModel settings; // TODO: Add your custom settings model
  final Map<String, dynamic> settings; // Temporary placeholder

  const SettingsLoaded({required this.settings});

  @override
  List<Object> get props => [settings];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({required this.message});

  @override
  List<Object> get props => [message];
}

class LanguageChanged extends SettingsState {
  final String newLanguage;

  const LanguageChanged({required this.newLanguage});

  @override
  List<Object> get props => [newLanguage];
}

class ThemeChanged extends SettingsState {
  final bool isDarkMode;

  const ThemeChanged({required this.isDarkMode});

  @override
  List<Object> get props => [isDarkMode];
}

class NotificationsToggled extends SettingsState {
  final bool isEnabled;

  const NotificationsToggled({required this.isEnabled});

  @override
  List<Object> get props => [isEnabled];
}
 
import 'package:equatable/equatable.dart';

// import '../../data/models/social_link_model.dart'; // TODO: Add your custom social link model
// import '../../data/models/user_profile_model.dart'; // TODO: Add your custom user profile model

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  // final UserProfileModel userProfile; // TODO: Add your custom user profile model
  final Map<String, dynamic> userProfile; // Temporary placeholder

  const UserProfileLoaded({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserProfileUpdating extends UserProfileState {}

class UserProfileUpdated extends UserProfileState {
  // final UserProfileModel userProfile; // TODO: Add your custom user profile model
  final Map<String, dynamic> userProfile; // Temporary placeholder

  const UserProfileUpdated({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

class SkillAdded extends UserProfileState {
  final String skill;

  const SkillAdded({required this.skill});

  @override
  List<Object> get props => [skill];
}

class SkillRemoved extends UserProfileState {
  final String skill;

  const SkillRemoved({required this.skill});

  @override
  List<Object> get props => [skill];
}

class SocialLinkAdded extends UserProfileState {
  // final SocialLinkModel socialLink; // TODO: Add your custom social link model
  final Map<String, dynamic> socialLink; // Temporary placeholder

  const SocialLinkAdded({required this.socialLink});

  @override
  List<Object> get props => [socialLink];
}

class SocialLinkRemoved extends UserProfileState {
  final String socialLinkId;

  const SocialLinkRemoved({required this.socialLinkId});

  @override
  List<Object> get props => [socialLinkId];
}

class SocialLinkUpdated extends UserProfileState {
  // final SocialLinkModel socialLink; // TODO: Add your custom social link model
  final Map<String, dynamic> socialLink; // Temporary placeholder

  const SocialLinkUpdated({required this.socialLink});

  @override
  List<Object> get props => [socialLink];
}

class ProfileImageUpdating extends UserProfileState {}

class ProfileImageUpdated extends UserProfileState {
  final String newImageUrl;

  const ProfileImageUpdated({required this.newImageUrl});

  @override
  List<Object> get props => [newImageUrl];
}

class PasswordChanging extends UserProfileState {}

class PasswordChanged extends UserProfileState {}

class ValidationError extends UserProfileState {
  final String field;
  final String message;

  const ValidationError({required this.field, required this.message});

  @override
  List<Object> get props => [field, message];
}
 
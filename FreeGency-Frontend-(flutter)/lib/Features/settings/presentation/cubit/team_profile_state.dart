import 'package:equatable/equatable.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';

// import '../../data/models/social_link_model.dart'; // TODO: Add your custom social link model
// import '../../data/models/team_profile_model.dart'; // TODO: Add your custom team profile model

abstract class TeamProfileState extends Equatable {
  const TeamProfileState();

  @override
  List<Object> get props => [];
}

class TeamProfileInitial extends TeamProfileState {}

class TeamProfileLoading extends TeamProfileState {}

class TeamProfileLoaded extends TeamProfileState {
  final TeamsModel teamProfile;

  const TeamProfileLoaded({required this.teamProfile});

  @override
  List<Object> get props => [teamProfile];
}

class TeamProfileError extends TeamProfileState {
  final String message;

  const TeamProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class TeamProfileUpdating extends TeamProfileState {}

class TeamProfileUpdated extends TeamProfileState {
  final String message;

  const TeamProfileUpdated({required this.message});

  @override
  List<Object> get props => [message];
}

class TeamSocialLinkAdded extends TeamProfileState {
  // final SocialLinkModel socialLink; // TODO: Add your custom social link model
  final Map<String, dynamic> socialLink; // Temporary placeholder

  const TeamSocialLinkAdded({required this.socialLink});

  @override
  List<Object> get props => [socialLink];
}

class TeamSocialLinkRemoved extends TeamProfileState {
  final String socialLinkId;

  const TeamSocialLinkRemoved({required this.socialLinkId});

  @override
  List<Object> get props => [socialLinkId];
}

class TeamSocialLinkUpdated extends TeamProfileState {
  // final SocialLinkModel socialLink; // TODO: Add your custom social link model
  final Map<String, dynamic> socialLink; // Temporary placeholder

  const TeamSocialLinkUpdated({required this.socialLink});

  @override
  List<Object> get props => [socialLink];
}

class TeamLogoUpdating extends TeamProfileState {}

class TeamLogoUpdated extends TeamProfileState {
  final String logoUrl;

  const TeamLogoUpdated({required this.logoUrl});

  @override
  List<Object> get props => [logoUrl];
}

class TeamPasswordChanging extends TeamProfileState {}

class TeamPasswordChanged extends TeamProfileState {}

class TeamPasswordError extends TeamProfileState {
  final String message;

  const TeamPasswordError({required this.message});

  @override
  List<Object> get props => [message];
}

class TeamValidationError extends TeamProfileState {
  final String field;
  final String message;

  const TeamValidationError({required this.field, required this.message});

  @override
  List<Object> get props => [field, message];
}

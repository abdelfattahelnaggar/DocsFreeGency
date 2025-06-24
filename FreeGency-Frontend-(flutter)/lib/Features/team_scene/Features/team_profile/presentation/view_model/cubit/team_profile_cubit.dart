import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/data/repositories/team_profile_repo.dart';
import 'package:meta/meta.dart';

part 'team_profile_state.dart';

class TeamProfileCubit extends Cubit<TeamProfileState> {
  TeamProfileCubit({required this.teamProfileRepo})
      : super(TeamProfileInitial());

  final TeamProfileRepo teamProfileRepo;
  TeamsModel? myTeam;
  List<ProjectModel> teamProjects = [];
  bool showAllProjects = false;
  bool isLoading = false;

  Future<void> getMyTeamProfile() async {
    if (isLoading) return; // Prevent multiple simultaneous calls

    isLoading = true;
    emit(TeamProfileLoading());

    final result = await teamProfileRepo.getMyTeamProfile();
    result.fold((failure) {
      emit(TeamProfileError(errorMessage: failure.errorMessage));
    }, (team) {
      myTeam = team;
      emit(TeamProfileSuccess(team: team));
    });

    isLoading = false;
  }

  Future<void> updateTeamProfile(Map<String, dynamic> data) async {
    if (isLoading) return;

    isLoading = true;
    emit(TeamProfileUpdateLoading());

    final result = await teamProfileRepo.updateTeamProfile(data);
    result.fold((failure) {
      emit(TeamProfileUpdateError(errorMessage: failure.errorMessage));
    }, (message) {
      emit(TeamProfileUpdateSuccess(message: message));
      getMyTeamProfile(); // Refresh team profile after update
    });

    isLoading = false;
  }

  Future<void> updateTeamLogo(String imagePath) async {
    if (isLoading) return;

    isLoading = true;
    emit(TeamLogoUpdateLoading());

    final result = await teamProfileRepo.updateTeamLogo(imagePath);
    result.fold((failure) {
      emit(TeamLogoUpdateError(errorMessage: failure.errorMessage));
      isLoading = false;
    }, (message) {
      emit(TeamLogoUpdateSuccess(message: message));
      isLoading = false;
    });
  }

  Future<void> getTeamProjects() async {
    // Allow projects to load independently of team profile
    emit(TeamProjectsLoading());

    final result = await teamProfileRepo.getTeamProjects();
    result.fold((failure) {
      emit(TeamProjectsError(errorMessage: failure.errorMessage));
    }, (projects) {
      teamProjects = projects;
      emit(TeamProjectsSuccess(projects: projects));
    });
  }

  void toggleShowAllProjects() {
    try {
      showAllProjects = !showAllProjects;
      emit(TeamProfileRefresh());

      // Force another emission to ensure the UI updates
      Future.delayed(const Duration(milliseconds: 100), () {
        emit(TeamProfileRefresh());
      });
    } catch (e) {
      // Handle error
    }
  }

  // For debugging
  void printTeamInfo() {
    log('Team info: ${myTeam?.name}, Logo: ${myTeam?.logo}, Skills: ${myTeam?.skills?.length}, Rating: ${myTeam?.averageRating}');
  }
}

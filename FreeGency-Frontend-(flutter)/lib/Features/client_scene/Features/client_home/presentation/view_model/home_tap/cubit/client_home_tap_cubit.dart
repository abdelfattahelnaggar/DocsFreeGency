import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/client_home_repository/client_home_tap_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/project_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:meta/meta.dart';

part 'client_home_tap_state.dart';

class ClientHomeTapCubit extends Cubit<ClientHomeTapState> {
  ClientHomeTapCubit(this.clientHomeTapRepo) : super(ClientHomeTapInitial());
  final ClientHomeTapRepo clientHomeTapRepo;

  // Cache data
  List<TeamsModel>? _cachedTeams;
  List<ProjectModel>? _cachedProjects;
  bool _hasLoadedData = false;

  // Getters
  bool get hasTeamsData => _cachedTeams != null;
  bool get hasProjectsData => _cachedProjects != null;
  bool get hasAllData =>
      _hasLoadedData && _cachedTeams != null && _cachedProjects != null;
  List<TeamsModel>? get cachedTeams => _cachedTeams;
  List<ProjectModel>? get cachedProjects => _cachedProjects;

  Future<void> getTopRatedTeams({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedTeams != null) {
      emit(ClientHomeTapTopRatedSuccess(_cachedTeams!));
      return;
    }

    emit(ClientHomeTapTopRatedLoading());
    final result = await clientHomeTapRepo.getTopRatedTeams();
    result.fold((failure) {
      emit(ClientHomeTapTopRatedFailure(failure.errorMessage));
    }, (teams) {
      _cachedTeams = teams;
      emit(ClientHomeTapTopRatedSuccess(teams));
    });
  }

  Future<void> getInerstedProjects({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedProjects != null) {
      emit(ClientHomeTapInerstedProjectsSuccess(_cachedProjects!));
      return;
    }

    emit(ClientHomeTapInerstedProjectsLoading());
    final result = await clientHomeTapRepo.getInerstedProjects();
    result.fold((failure) {
      emit(ClientHomeTapInerstedProjectsFailure(failure.errorMessage));
    }, (projects) {
      _cachedProjects = projects;
      emit(ClientHomeTapInerstedProjectsSuccess(projects));
    });
  }

  Future<void> getAllData({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _hasLoadedData &&
        _cachedTeams != null &&
        _cachedProjects != null) {
      emit(ClientHomeTapAllDataSuccess(_cachedTeams!, _cachedProjects!));
      return;
    }

    emit(ClientHomeTapAllDataLoading());

    try {
      // Get teams data
      final teamsResult = await clientHomeTapRepo.getTopRatedTeams();
      List<TeamsModel> teams = [];
      bool teamsSuccess = false;

      teamsResult.fold((failure) {
        // Just log the error but continue with empty teams
        log("Teams error: ${failure.errorMessage}");
      }, (teamsData) {
        teams = teamsData;
        teamsSuccess = true;
      });

      // Get projects data
      final projectsResult = await clientHomeTapRepo.getInerstedProjects();
      List<ProjectModel> projects = [];
      bool projectsSuccess = false;

      projectsResult.fold((failure) {
        // Just log the error but continue with empty projects
        log("Projects error: ${failure.errorMessage}");
      }, (projectsData) {
        projects = projectsData;
        projectsSuccess = true;
      });

      // Update cache and emit success state even if one of them failed
      // This way we'll at least show partial data
      _cachedTeams = teams;
      _cachedProjects = projects;
      _hasLoadedData = true;

      if (teamsSuccess || projectsSuccess) {
        emit(ClientHomeTapAllDataSuccess(teams, projects));
      } else {
        // Only emit failure if both failed
        emit(ClientHomeTapAllDataFailure("Failed to load data"));
      }
    } catch (e) {
      log("Exception in getAllData: ${e.toString()}");
      emit(ClientHomeTapAllDataFailure(e.toString()));
    }
  }

  Future<void> refreshAllData() async {
    await getAllData(forceRefresh: true);
  }
}

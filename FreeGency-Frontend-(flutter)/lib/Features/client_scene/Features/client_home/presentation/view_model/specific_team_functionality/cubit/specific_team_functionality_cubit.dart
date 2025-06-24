import 'package:bloc/bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/client_home_repository/client_home_tap_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:meta/meta.dart';

part 'specific_team_functionality_state.dart';

class SpecificTeamFunctionalityCubit extends Cubit<SpecificTeamFunctionalityState> {
  SpecificTeamFunctionalityCubit(this.clientHomeTapRepo) : super(SpecificTeamFunctionalityInitial());

  final ClientHomeTapRepo clientHomeTapRepo;

  Future<void> getSpecificTeam(String teamId) async {
    emit(SpecificTeamFunctionalityLoading());
    final result = await clientHomeTapRepo.getSpecificTeam(teamId);
    result.fold((failure) {
      emit(SpecificTeamFunctionalityError(error: failure.errorMessage));
    }, (team) {
      emit(SpecificTeamFunctionalityLoaded(team: team));
    });
  }
}

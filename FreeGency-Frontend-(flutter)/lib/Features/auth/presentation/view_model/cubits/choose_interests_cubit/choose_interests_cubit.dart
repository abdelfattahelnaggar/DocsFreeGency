import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/data/repositories/select_interests_repo.dart';

import 'choose_interests_state.dart';

// Cubit
class ChooseInterestsCubit extends Cubit<ChooseInterestsState> {
  ChooseInterestsCubit() : super(const ChooseInterestsInitial());
  final SelectInterestsRepo selectInterestsRepo =
      SelectInterestsRepoImplementation();

  void toggleInterest(String categoryId) {
    final currentInterests = List<String>.from(state.selectedInterests);

    if (currentInterests.contains(categoryId)) {
      currentInterests.remove(categoryId);
    } else {
      currentInterests.add(categoryId);
    }

    emit(ChooseInterestsState(selectedInterests: currentInterests));
  }

  void setInitialInterests(List<String> interests) {
    emit(ChooseInterestsState(selectedInterests: interests));
  }

  Future<void> sendInterests(List<String> categoryIds) async {
    emit(ChooseInterestsLoading());
    final result = await selectInterestsRepo.sendInterests(categoryIds);
    result.fold(
      (failure) => emit(ChooseInterestsFailure(failure.errorMessage)),
      (_) =>
          emit(ChooseInterestsSuccess()), // We only care if it was successful
    );
  }
}

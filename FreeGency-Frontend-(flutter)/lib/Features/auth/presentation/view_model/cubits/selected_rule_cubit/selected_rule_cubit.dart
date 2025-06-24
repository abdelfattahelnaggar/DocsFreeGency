import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/data/models/guest_rule_model.dart';

part 'selected_rule_state.dart';

class SelectedRuleCubit extends Cubit<SelectedRuleState> {
  SelectedRuleCubit() : super(SelectedRuleInitial());

  List<GuestRuleModel> guestRules = GuestRuleModel.guestRules
      .map(
        (e) => GuestRuleModel.fromJson(e),
      )
      .toList();
  int index = 0;

  void updateSelectedRule(int index) {
    if (index == 0) {
      emit(ClientRuleSelectedState());
    } else {
      emit(TeamLeaderRuleSelectedState());
    }
  }
}

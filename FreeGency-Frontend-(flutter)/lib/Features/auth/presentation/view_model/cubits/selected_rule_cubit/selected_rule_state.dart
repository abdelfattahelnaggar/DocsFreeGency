part of 'selected_rule_cubit.dart';

@immutable
sealed class SelectedRuleState {}

final class SelectedRuleInitial extends SelectedRuleState {}

final class ClientRuleSelectedState extends SelectedRuleState {}

final class TeamLeaderRuleSelectedState extends SelectedRuleState {}

// final class ContinueAsGuestState extends SelectedRuleState {}

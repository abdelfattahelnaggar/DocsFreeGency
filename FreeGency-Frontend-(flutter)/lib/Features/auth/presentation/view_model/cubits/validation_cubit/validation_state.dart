part of 'validation_cubit.dart';

@immutable
sealed class ValidationState {}

final class ValidatioInitial extends ValidationState {}

final class ValidationSuccessState extends ValidationState {}

final class ValidatioErrorState extends ValidationState {}

class PasswordChecklistUpdated extends ValidationState {
  final Map<PasswordRequirement, bool> checklist;
  PasswordChecklistUpdated(this.checklist);
}

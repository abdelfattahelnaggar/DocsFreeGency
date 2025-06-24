import 'package:equatable/equatable.dart';

class ChooseInterestsState extends Equatable {
  final List<String> selectedInterests;

  const ChooseInterestsState({
    this.selectedInterests = const [],
  });

  @override
  List<Object?> get props => [selectedInterests];
}

class ChooseInterestsInitial extends ChooseInterestsState {
  const ChooseInterestsInitial() : super();
}

class ChooseInterestsLoading extends ChooseInterestsState {}

class ChooseInterestsSuccess extends ChooseInterestsState {}

class ChooseInterestsFailure extends ChooseInterestsState {
  final String errorMessage;
  const ChooseInterestsFailure(this.errorMessage);
}

part of 'proposal_functionality_cubit.dart';

@immutable
sealed class ProposalFunctionalityState {}

final class ProposalFunctionalityInitial extends ProposalFunctionalityState {}

final class GetProposalByIdLoading extends ProposalFunctionalityState {}

final class GetProposalByIdSuccess extends ProposalFunctionalityState {
  final ProposalModel proposal;
  GetProposalByIdSuccess(this.proposal);
}

final class GetProposalByIdError extends ProposalFunctionalityState {
  final String errorMessage;
  GetProposalByIdError(this.errorMessage);
}

final class AcceptTeamRequestLoading extends ProposalFunctionalityState {
  final String teamRequestId;

  AcceptTeamRequestLoading(this.teamRequestId);
}

final class AcceptTeamRequestError extends ProposalFunctionalityState {
  final String errorMessage;
  AcceptTeamRequestError(this.errorMessage);
}

final class AcceptTeamRequestSuccess extends ProposalFunctionalityState {}

final class SubmitProposalLoading extends ProposalFunctionalityState {}

final class SubmitProposalError extends ProposalFunctionalityState {
  final String errorMessage;
  SubmitProposalError(this.errorMessage);
}

final class SubmitProposalSuccess extends ProposalFunctionalityState {}

final class FilePickedSuccessfully extends ProposalFunctionalityState {
  final File file;
  FilePickedSuccessfully(this.file);
}

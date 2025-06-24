import 'package:dartz/dartz.dart';
import 'package:freegency_gp/core/errors/failures.dart';
import 'package:freegency_gp/core/shared/data/models/proposal_model.dart';

abstract class ProposalRepository {
  Future<Either<Failure, ProposalModel>> getProposalById(String proposalId);
  Future<Either<Failure, void>> acceptTeamRequest(String teamRequestId);
  Future<Either<Failure, void>> submitProposal({
    required String taskId,
    required String note,
    required int budget,
    String? similarProjectUrl,
    List<Map<String, dynamic>>? proposalFiles,
  });
}

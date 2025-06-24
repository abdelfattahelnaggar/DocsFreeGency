import 'dart:io';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freegency_gp/core/shared/data/models/proposal_model.dart';
import 'package:freegency_gp/core/shared/data/repositories/proposal_repo/proposal_repository.dart';
import 'package:meta/meta.dart';
import 'package:file_picker/file_picker.dart';

part 'proposal_functionality_state.dart';

class ProposalFunctionalityCubit extends Cubit<ProposalFunctionalityState> {
  ProposalFunctionalityCubit(this.proposalRepo)
      : super(ProposalFunctionalityInitial());
  ProposalRepository proposalRepo;
  String? lastProcessedId;
  ProposalModel? lastProposal;
  File? pickedFile;

  Future<void> getProposalById(String proposalId) async {
    emit(GetProposalByIdLoading());
    var result = await proposalRepo.getProposalById(proposalId);

    result.fold(
      (failure) => emit(GetProposalByIdError(failure.errorMessage)),
      (proposal) {
        lastProposal = proposal;
        emit(GetProposalByIdSuccess(proposal));
      },
    );
  }

  Future<void> acceptTeamRequest(String teamRequestId) async {
    lastProcessedId = teamRequestId;
    emit(AcceptTeamRequestLoading(teamRequestId));
    var result = await proposalRepo.acceptTeamRequest(teamRequestId);
    result.fold(
      (failure) => emit(AcceptTeamRequestError(failure.errorMessage)),
      (_) => emit(AcceptTeamRequestSuccess()),
    );
  }

  Future<void> submitProposal({
    required String taskId,
    required String note,
    required int budget,
    String? similarProjectUrl,
  }) async {
    emit(SubmitProposalLoading());
    List<Map<String, dynamic>>? proposalFiles;
    if (pickedFile != null) {
      proposalFiles = [
        {
          'fileName': pickedFile!.path.split('/').last,
          'fileUrl': pickedFile!.path,
        }
      ];
    }

    var result = await proposalRepo.submitProposal(
      taskId: taskId,
      note: note,
      budget: budget,
      similarProjectUrl: similarProjectUrl,
      proposalFiles: proposalFiles,
    );

    result.fold(
      (failure) => emit(SubmitProposalError(failure.errorMessage)),
      (_) => emit(SubmitProposalSuccess()),
    );
  }

  Future<File?> chooseFileFromDevice() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png', 'zip', 'jpeg'],
      );

      if (result != null && result.files.single.path != null) {
        pickedFile = File(result.files.single.path!);

        log('✅ File Name: ${result.files.single.name}');
        log('📁 File Path: ${pickedFile!.path}');
        log('📦 File Size: ${result.files.single.size} bytes');

        emit(FilePickedSuccessfully(pickedFile!));
        return pickedFile;
      } else {
        log('❌ No file selected');
        emit(SubmitProposalError('No file selected'));
        return null;
      }
    } catch (e, stackTrace) {
      log('❌ Exception: $e\n$stackTrace');
      emit(SubmitProposalError(e.toString()));
      return null;
    }
  }

  void clearFile() {
    pickedFile = null;
    emit(ProposalFunctionalityInitial());
  }
}

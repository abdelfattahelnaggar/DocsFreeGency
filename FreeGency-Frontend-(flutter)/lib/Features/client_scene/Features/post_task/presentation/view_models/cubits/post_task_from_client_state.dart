part of 'post_task_from_client_cubit.dart';

sealed class PostTaskFromClientState {}

final class PostTaskFromClientInitial extends PostTaskFromClientState {}

final class PostTaskFromClientSuccess extends PostTaskFromClientState {
  final PostTaskResponseModel postTaskResponseModel;

  PostTaskFromClientSuccess(this.postTaskResponseModel);
}

final class PostTaskFromClientLoading extends PostTaskFromClientState {}

final class PostTaskFromClientError extends PostTaskFromClientState {
  final String errorMessage;

  PostTaskFromClientError({required this.errorMessage});
}

final class FilePickedSuccessfully extends PostTaskFromClientState {
  final File file;

  FilePickedSuccessfully(this.file);
}

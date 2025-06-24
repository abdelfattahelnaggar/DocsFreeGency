part of 'post_project_cubit.dart';

sealed class PostProjectState {}

final class PostProjectInitial extends PostProjectState {}

final class PostProjectSuccess extends PostProjectState {
  final PostProjectResponseModel postProjectResponseModel;

  PostProjectSuccess(this.postProjectResponseModel);
}

final class PostProjectLoading extends PostProjectState {}

final class PostProjectError extends PostProjectState {
  final String errorMessage;

  PostProjectError({required this.errorMessage});
}

final class ImagesPickedSuccessfully extends PostProjectState {
  final List<File> images;

  ImagesPickedSuccessfully(this.images);
}

final class TechnologiesUpdated extends PostProjectState {
  final List<String> technologies;

  TechnologiesUpdated(this.technologies);
}

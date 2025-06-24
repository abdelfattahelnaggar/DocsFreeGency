part of 'client_home_page_cubit.dart';

abstract class ClientHomePageState {}

class ClientHomePageInitial extends ClientHomePageState {}

class ClientHomePageLoading extends ClientHomePageState {}

class ClientHomePageLoaded extends ClientHomePageState {}

class ClientHomePageError extends ClientHomePageState {
  final String message;
  ClientHomePageError(this.message);
}

class ClientHomePageFabVisibilityChanged extends ClientHomePageState {
  final bool isVisible;
  ClientHomePageFabVisibilityChanged(this.isVisible);
}

class ClientHomePageScreenVisited extends ClientHomePageState {
  final int screenIndex;
  ClientHomePageScreenVisited(this.screenIndex);
}

class ClientHomePageScreenRefreshed extends ClientHomePageState {
  final int screenIndex;
  ClientHomePageScreenRefreshed(this.screenIndex);
}

class ClientHomePageCacheCleared extends ClientHomePageState {}

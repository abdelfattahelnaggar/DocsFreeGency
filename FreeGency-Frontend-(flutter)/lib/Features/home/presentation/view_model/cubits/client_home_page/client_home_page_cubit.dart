import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';

part 'client_home_page_state.dart';

class ClientHomePageCubit extends Cubit<ClientHomePageState> {
  ClientHomePageCubit() : super(ClientHomePageInitial());

  // User role flags
  bool _isClient = false;
  bool _isTeamLeader = false;
  bool _isTeamMember = false;
  bool _isGuest = false;

  // UI state
  bool _isFabVisible = true;
  bool _isInitialized = false;

  // Lazy loading state
  final Set<int> _visitedScreens = {};

  // Scroll controllers management
  final Map<String, ScrollController> _scrollControllers = {};

  // Getters
  bool get isClient => _isClient;
  bool get isTeamLeader => _isTeamLeader;
  bool get isTeamMember => _isTeamMember;
  bool get isGuest => _isGuest;
  bool get isFabVisible => _isFabVisible;
  bool get isInitialized => _isInitialized;
  Set<int> get visitedScreens => Set.from(_visitedScreens);

  String get currentUserRole {
    if (_isClient) return 'client';
    if (_isTeamLeader) return 'teamLeader';
    if (_isTeamMember) return 'teamMember';
    return 'guest';
  }

  int get totalScreensCount {
    if (_isClient) return 4;
    if (_isTeamLeader) return 5;
    if (_isTeamMember) return 5;
    return 3; // guest
  }

  // Initialize user data and check role
  Future<void> initializeUser() async {
    emit(ClientHomePageLoading());

    try {
      // Check if user is logged in
      final isLoggedIn = await LocalStorage.isLoggedIn();

      if (!isLoggedIn) {
        // If not logged in, check if we have guest data
        final userData = await LocalStorage.getUserData();
        if (userData == null) {
          // If no guest data exists, create and store guest user data
          await LocalStorage.setGuestUserData();
        }
      }

      // Now check the user role
      await _checkUserRole();

      emit(ClientHomePageLoaded());
    } catch (e) {
      emit(ClientHomePageError('Failed to initialize user: $e'));
    }
  }

  // Check and update user role
  Future<void> _checkUserRole() async {
    final previousRole = currentUserRole;

    _isClient = await LocalStorage.isClient();
    _isTeamLeader = await LocalStorage.isTeamLeader();
    _isTeamMember = await LocalStorage.isTeamMember();
    _isGuest = await LocalStorage.isGuest();

    _isInitialized = true;

    // Clear visited screens if user role changed
    final newRole = currentUserRole;
    if (previousRole != newRole) {
      _visitedScreens.clear();
      _visitedScreens.add(0); // Always keep home screen visited

      // Clear all scroll controllers when role changes
      _disposeAllScrollControllers();
    }
  }

  // Get or create scroll controller for a specific screen
  ScrollController getScrollController(String key) {
    if (!_scrollControllers.containsKey(key)) {
      _scrollControllers[key] = ScrollController();
      _scrollControllers[key]!.addListener(_handleScroll);
    }
    return _scrollControllers[key]!;
  }

  // Get current active scroll controller based on current tab
  ScrollController? getCurrentScrollController(int currentIndex) {
    if (_isClient) {
      switch (currentIndex) {
        case 0:
          return getScrollController('client_home');
        case 2:
          return getScrollController('client_profile');
        case 3:
          return getScrollController('client_jobs');
      }
    } else if (_isTeamMember) {
      switch (currentIndex) {
        case 0:
          return getScrollController('client_home');
        case 2:
          return getScrollController('member_profile1');
        case 4:
          return getScrollController('member_jobs');
      }
    } else if (_isGuest) {
      switch (currentIndex) {
        case 0:
          return getScrollController('guest_home');
        case 1:
          return getScrollController('guest_profile');
        case 2:
          return getScrollController('guest_jobs');
      }
    }
    return null;
  }

  // Handle scroll changes for FAB visibility
  void _handleScroll() {
    // This will be called by scroll controllers
    // We need to get the current active controller to determine FAB visibility
    // This will be handled in the UI layer since we need current tab index
  }

  // Update FAB visibility
  void updateFabVisibility(bool visible) {
    if (_isFabVisible != visible) {
      _isFabVisible = visible;
      emit(ClientHomePageFabVisibilityChanged(visible));
    }
  }

  // Mark screen as visited and trigger rebuild
  void markScreenAsVisited(int index) {
    if (!_visitedScreens.contains(index)) {
      _visitedScreens.add(index);
      emit(ClientHomePageScreenVisited(index));
    }
  }

  // Check if screen has been visited
  bool isScreenVisited(int index) {
    // Always load screen 0 (home) by default
    if (index == 0) {
      _visitedScreens.add(0);
    }
    return _visitedScreens.contains(index);
  }

  // Refresh a specific screen (force re-visit)
  void refreshScreen(int screenIndex) {
    // Remove from visited screens to force recreation
    _visitedScreens.remove(screenIndex);

    // Clear scroll controller for this screen
    _clearScrollControllerForScreen(screenIndex);

    // Mark as visited again to trigger recreation
    _visitedScreens.add(screenIndex);
    emit(ClientHomePageScreenRefreshed(screenIndex));
  }

  // Clear all visited screens
  void clearAllScreensCache() {
    _visitedScreens.clear();
    _visitedScreens.add(0); // Keep home screen visited

    // Clear all scroll controllers
    _disposeAllScrollControllers();

    emit(ClientHomePageCacheCleared());
  }

  // Helper method to clear scroll controller for a specific screen
  void _clearScrollControllerForScreen(int screenIndex) {
    String? keyToRemove;

    if (_isClient) {
      switch (screenIndex) {
        case 0:
          keyToRemove = 'client_home';
          break;
        case 2:
          keyToRemove = 'client_profile';
          break;
        case 3:
          keyToRemove = 'client_jobs';
          break;
      }
    } else if (_isTeamMember) {
      switch (screenIndex) {
        case 0:
          keyToRemove = 'client_home';
          break;
        case 2:
          keyToRemove = 'member_profile1';
          break;
        case 4:
          keyToRemove = 'member_jobs';
          break;
      }
    } else if (_isGuest) {
      switch (screenIndex) {
        case 0:
          keyToRemove = 'guest_home';
          break;
        case 1:
          keyToRemove = 'guest_profile';
          break;
        case 2:
          keyToRemove = 'guest_jobs';
          break;
      }
    }

    if (keyToRemove != null && _scrollControllers.containsKey(keyToRemove)) {
      _scrollControllers[keyToRemove]?.dispose();
      _scrollControllers.remove(keyToRemove);
    }
  }

  // Dispose all scroll controllers
  void _disposeAllScrollControllers() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    _scrollControllers.clear();
  }

  @override
  Future<void> close() {
    _disposeAllScrollControllers();
    _visitedScreens.clear();
    return super.close();
  }
}

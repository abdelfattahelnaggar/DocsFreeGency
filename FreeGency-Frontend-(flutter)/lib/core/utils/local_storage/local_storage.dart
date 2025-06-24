import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static const String _onboardingKey = 'onboarding_completed';
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userDataKey = 'user_data';

  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<void> setUserData(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(userModel.toJson());
    await prefs.setString(_userDataKey, userJson);
  }

  static Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userDataKey);


    if (userJson == null) {
      return null;
    }

    try {
      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  /// Gets the user role from stored user data
  static Future<String?> getUserRole() async {
    final userData = await getUserData();
    if (userData == null) {
      return null;
    }
    return userData.role;
  }

  /// Checks if the user has a specific role
  static Future<bool> hasRole(String role) async {
    final userRole = await getUserRole();
    if (userRole == null) {
      return false;
    }
    final result = userRole.toLowerCase() == role.toLowerCase();
    return result;
  }

  /// Checks if the user is a client
  static Future<bool> isClient() async {
    final result = await hasRole('client');
    return result;
  }

  /// Checks if the user is a team leader
  static Future<bool> isTeamLeader() async {
    final result = await hasRole('teamLeader');
    return result;
  }

  /// Checks if the user is a team member
  static Future<bool> isTeamMember() async {
    final result = await hasRole('teamMember');
    return result;
  }

  /// Checks if the user is a guest
  static Future<bool> isGuest() async {
    final result = await hasRole('guest');
    return result;
  }

  /// Clears the stored user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
  }

  /// Stores guest user data
  static Future<void> setGuestUserData() async {
    final guestUser = UserModel(
      ratingCount: 0,
      isVerified: false,
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      role: 'guest',
      name: 'Guest User',
      email: 'guest@freegency.com',
      teams: [],
      skills: [],
      image: '',
      interests: [],
      averageRating: 0 ,
    );
    await setUserData(guestUser);
  }

  /// Clears all user-related data including auth and user model
  static Future<void> clearAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
}

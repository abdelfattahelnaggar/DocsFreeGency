import 'package:freegency_gp/core/utils/helpers/validators.dart';

class ValidationRepository {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.isValidEmail()) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!value.isValidPassword()) {
      return 'Password must be at least 8 characters long\nand contain at least one uppercase letter, one lowercase letter, one digit, and one special character.';
    }
    return null;
  }

  String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}

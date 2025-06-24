extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(this);
  }
}

extension PasswordValidator on String {
  bool isValidPassword() {
    // Password must be at least 8 characters long
    // and contain at least one uppercase letter, one lowercase letter, one digit and one special character.
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    ).hasMatch(this);
  }
}

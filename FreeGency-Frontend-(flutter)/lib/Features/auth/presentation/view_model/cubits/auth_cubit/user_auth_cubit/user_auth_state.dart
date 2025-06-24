abstract class UserAuthStates {}

class AuthInitial extends UserAuthStates {}

// User Registration States
class UserAuthLoading extends UserAuthStates {}

class UserAuthSuccess extends UserAuthStates {
  final String? nextRoute;
  UserAuthSuccess({this.nextRoute});
}

class UserAuthError extends UserAuthStates {
  final String errorMessage;
  UserAuthError(this.errorMessage);
}

// Forget Password States
class UserAuthForgetPasswordLoading extends UserAuthStates {}

class UserAuthForgetPasswordSuccess extends UserAuthStates {}

class UserAuthForgetPasswordError extends UserAuthStates {
  final String errorMessage;
  UserAuthForgetPasswordError(this.errorMessage);
}

// Verify Email States
class UserAuthVerifyEmailLoading extends UserAuthStates {}

class UserAuthVerifyEmailSuccess extends UserAuthStates {}

class UserAuthVerifyEmailError extends UserAuthStates {
  final String errorMessage;
  UserAuthVerifyEmailError(this.errorMessage);
}

// Reset Password States
class UserAuthResetPasswordLoading extends UserAuthStates {}

class UserAuthResetPasswordSuccess extends UserAuthStates {}

class UserAuthResetPasswordError extends UserAuthStates {
  final String errorMessage;
  UserAuthResetPasswordError(this.errorMessage);
}

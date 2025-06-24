class UserLoginRequestModel {
  final String email;
  final String password;
  final String? fcmToken;

  UserLoginRequestModel({
    required this.email,
    required this.password,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    // Only add fcmToken if it's not null
    if (fcmToken != null) {
      data['fcmToken'] = fcmToken;
    }

    return data;
  }
}

class TeamRegisterOrCreateRequestModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String teamName;
  final String category;
  final String teamCode;

  TeamRegisterOrCreateRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.teamName,
    required this.category,
    required this.teamCode,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "teamName": teamName,
        "category": category,
        "teamCode": teamCode,
      };
}

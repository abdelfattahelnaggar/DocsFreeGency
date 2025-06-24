class JoinTeamRequestModel {
  final String teamCode;
  final String job;

  JoinTeamRequestModel({
    required this.teamCode,
    required this.job,
  });

  Map<String, dynamic> toJson() => {
        "teamCode": teamCode,
        "job": job,
      };
}

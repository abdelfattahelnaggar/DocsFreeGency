class GuestRuleModel {
  final String text;
  final String image;

  GuestRuleModel({required this.text, required this.image});

  factory GuestRuleModel.fromJson(Map<String, dynamic> json) {
    return GuestRuleModel(
      text: json['text'],
      image: json['image'],
    );
  }

  static List<Map<String, String>> guestRules = [
    {
      'text': 'user_type_client',
      'image': 'assets/images/onBoarding1.png',
    },
    {
      'text': 'user_type_team',
      'image': 'assets/images/onBoarding3.png',
    },
  ];
}

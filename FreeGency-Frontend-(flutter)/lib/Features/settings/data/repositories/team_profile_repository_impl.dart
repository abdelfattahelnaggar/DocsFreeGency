// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../models/edit_team_profile_request_model.dart';
import '../models/edit_team_profile_response_model.dart';
import 'team_profile_repository.dart';

class TeamProfileRepositoryImpl implements TeamProfileRepository {
  final String baseUrl =
      'https://your-api-base-url.com'; // Replace with actual API URL
  final http.Client httpClient;

  TeamProfileRepositoryImpl({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  @override
  Future<TeamData> loadTeamProfile() async {
    try {
      // TODO: Replace with actual API endpoint
      // final response = await httpClient.get(
      //   Uri.parse('$baseUrl/api/team/profile'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer YOUR_TOKEN_HERE',
      //   },
      // );

      // For now, return mock data
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay

      final mockResponse = {
        "contactInfo": {"email": "team@example.com", "phone": "01028133381"},
        "socialMediaLinks": {
          "linkedin": "https://www.linkedin.com/company/myteam",
          "facebook": "https://www.facebook.com/myteam",
          "website": "https://myteam.com",
          "github": "https://github.com/myteam"
        },
        "_id": "68569dde0e85db23a28d803d",
        "teamLeader": "68569ddd0e85db23a28d803b",
        "logo":
            "https://img.freepik.com/free-photo/rag-dolls-opposite-red-word-team-work_1156-194.jpg?semt=ais_hybrid&w=740",
        "name": "Dev 4 me",
        "teamCode": "EA610TK6UAK3CY1F",
        "category": "680d4c81ece14b0798bde6cf",
        "members": [
          {
            "user": "68569ddd0e85db23a28d803b",
            "role": "teamLeader",
            "job": "Team Leader",
            "joinedAt": "2025-06-21T11:56:14.126Z",
            "_id": "68569dde0e85db23a28d803e"
          },
          {
            "user": "68569e790e85db23a28d8067",
            "role": "teamMember",
            "job": "Flutter Developer",
            "joinedAt": "2025-06-21T20:11:00.595Z",
            "_id": "685711d4905799d629c5f952"
          }
        ],
        "skills": ["React", "Node.js", "MongoDB"],
        "Projects": [],
        "ratings": [],
        "averageRating": 0,
        "ratingCount": 0,
        "status": "active",
        "joinRequests": [],
        "clientTasks": [],
        "foundedAt": "2025-06-21T11:56:14.127Z",
        "createdAt": "2025-06-21T11:56:14.128Z",
        "updatedAt": "2025-06-21T20:13:10.538Z",
        "__v": 2,
        "aboutUs":
            "We are a forward-thinking Product & Development team passionate about transforming ideas into scalable digital experiences."
      };

      return TeamData.fromJson(mockResponse);

      // TODO: Uncomment when using real API
      // if (response.statusCode == 200) {
      //   final responseData = json.decode(response.body);
      //   return TeamData.fromJson(responseData['data']);
      // } else {
      //   throw Exception('Failed to load team profile: ${response.statusCode}');
      // }
    } catch (e) {
      throw Exception('Error loading team profile: $e');
    }
  }

  @override
  Future<EditTeamProfileResponseModel> updateTeamProfile(
      EditTeamProfileRequestModel request) async {
    try {
      // TODO: Replace with actual API endpoint
      // final response = await httpClient.put(
      //   Uri.parse('$baseUrl/api/team/profile'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer YOUR_TOKEN_HERE',
      //   },
      //   body: json.encode(request.toJson()),
      // );

      // For now, return mock response
      await Future.delayed(
          const Duration(seconds: 2)); // Simulate network delay

      final mockResponse = {
        "message": "success",
        "data": {
          "contactInfo": {
            "email": request.contactInfo.email,
            "phone": request.contactInfo.phone
          },
          "socialMediaLinks": request.socialMediaLinks.toJson(),
          "_id": "68569dde0e85db23a28d803d",
          "teamLeader": "68569ddd0e85db23a28d803b",
          "logo":
              "https://img.freepik.com/free-photo/rag-dolls-opposite-red-word-team-work_1156-194.jpg?semt=ais_hybrid&w=740",
          "name": request.name,
          "teamCode": "EA610TK6UAK3CY1F",
          "category": "680d4c81ece14b0798bde6cf",
          "members": [
            {
              "user": "68569ddd0e85db23a28d803b",
              "role": "teamLeader",
              "job": "Team Leader",
              "joinedAt": "2025-06-21T11:56:14.126Z",
              "_id": "68569dde0e85db23a28d803e"
            }
          ],
          "skills": request.skills,
          "Projects": [],
          "ratings": [],
          "averageRating": 0,
          "ratingCount": 0,
          "status": "active",
          "joinRequests": [],
          "clientTasks": [],
          "foundedAt": "2025-06-21T11:56:14.127Z",
          "createdAt": "2025-06-21T11:56:14.128Z",
          "updatedAt": DateTime.now().toIso8601String(),
          "__v": 2,
          "aboutUs": request.aboutUs
        }
      };

      return EditTeamProfileResponseModel.fromJson(mockResponse);

      // TODO: Uncomment when using real API
      // if (response.statusCode == 200) {
      //   final responseData = json.decode(response.body);
      //   return EditTeamProfileResponseModel.fromJson(responseData);
      // } else {
      //   throw Exception('Failed to update team profile: ${response.statusCode}');
      // }
    } catch (e) {
      throw Exception('Error updating team profile: $e');
    }
  }

  @override
  Future<String> updateTeamLogo(String imagePath) async {
    try {
      // TODO: Implement actual file upload
      // final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/team/logo'));
      // request.files.add(await http.MultipartFile.fromPath('logo', imagePath));
      // request.headers.addAll({
      //   'Authorization': 'Bearer YOUR_TOKEN_HERE',
      // });
      //
      // final response = await request.send();
      // if (response.statusCode == 200) {
      //   final responseData = await response.stream.bytesToString();
      //   final data = json.decode(responseData);
      //   return data['logoUrl'];
      // } else {
      //   throw Exception('Failed to update logo: ${response.statusCode}');
      // }

      // For now, return mock URL
      await Future.delayed(const Duration(seconds: 2));
      return 'https://example.com/new-team-logo.jpg';
    } catch (e) {
      throw Exception('Error updating team logo: $e');
    }
  }

  @override
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      // TODO: Replace with actual API endpoint
      // final response = await httpClient.put(
      //   Uri.parse('$baseUrl/api/team/change-password'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer YOUR_TOKEN_HERE',
      //   },
      //   body: json.encode({
      //     'currentPassword': currentPassword,
      //     'newPassword': newPassword,
      //   }),
      // );

      // For now, simulate success
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Uncomment when using real API
      // if (response.statusCode != 200) {
      //   throw Exception('Failed to change password: ${response.statusCode}');
      // }
    } catch (e) {
      throw Exception('Error changing password: $e');
    }
  }

  @override
  Future<void> navigateToManageTeamMembers() async {
    // TODO: Implement navigation logic
    // This might involve routing to a different screen
    await Future.delayed(const Duration(milliseconds: 500));
    // print('Navigate to manage team members');
  }

  @override
  Future<void> navigateToPaymentMethods() async {
    // TODO: Implement navigation logic
    // This might involve routing to a different screen
    await Future.delayed(const Duration(milliseconds: 500));
    // print('Navigate to payment methods');
  }
}

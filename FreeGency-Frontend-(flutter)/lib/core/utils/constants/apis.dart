class ApiConstants {
  static const baseUrl =
      "https://free-gency-backend-003bbc67b812.herokuapp.com";
  static const userRegisterEndPoint = "/api/v1/auth/signup";
  static const userLoginEndPoint = "/api/v1/auth/login";
  static const verifyEmailEndPoint = "/api/v1/auth/verify-reset-code";
  static const forgetPasswordEndPoint = "/api/v1/auth/forgot-password";
  static const resetPasswordEndPoint = "/api/v1/auth/reset-password";

  static const teamLoginEndPoint = 'auth/login';
  static const teamCreateOrSignUpEndPoint = 'auth/signup-team';

  static const categoriesEndPoint = 'categories';
  static const userProfileEndPoint = 'users/me';
  static const myTasksEndPoint = 'tasks/me';
  static const postTaskEndPoint = 'tasks';
  static const myNotification = 'notifications';
  static const specificTaskEndPoint = 'tasks';
  static const specificProposalEndPoint = 'tasks/requests';
  static const topRatedTeamsEndPoint = 'teams/top-rated';
  static const interestedProjectsEndPoint = 'projects/by-interests';
  static const projectsEndPoint = 'projects';
  static const specificTeamEndPoint = 'teams';
  static const getTasksByCategoryEndPoint = 'tasks/category';
  static const getSavedTasksEndPoint = 'tasks/saved';
  static const joinTeamEndPoint = 'teams/join';
  static const handleJoinRequestEndPoint = 'teams/requests';
  static const reviewsEndPoint = 'reviews';
  static const postJobEndPoint = 'jobs';
  static const subTasksEndPoint = 'subtasks';
}

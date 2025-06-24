import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/choose_interests_cubit/choose_interests_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/choose_interests_screen.dart';
import 'package:freegency_gp/Features/auth/presentation/views/client_auth_screen/views/client_login_auth_screen.dart';
import 'package:freegency_gp/Features/auth/presentation/views/main/views/main_auth_screen.dart';
import 'package:freegency_gp/Features/auth/presentation/views/reset_password_screen.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/views/team_leader_login_screen.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/client_home_repository/implemented_client_home_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/view_model/explore_services/cubit/exploring_progects_with_categories_and_services_cubit_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/views/exlore_services.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/views/project_inspiration_page.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/views/specific_team_profile.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/data/repositories/implementation_post_task_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/view_models/cubits/post_task_from_client_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/views/post_task_screen.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/views/view_proposal_details.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/repositories/implement_user_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/user_data_functionality_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/views/settings_screen.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/views/view_all_proposals_screen.dart';
import 'package:freegency_gp/Features/home/presentation/view_model/cubits/change_btn_nav_bar/change_btn_nav_bar_cubit.dart';
import 'package:freegency_gp/Features/home/presentation/views/client_home_page.dart';
import 'package:freegency_gp/Features/settings/presentation/views/edit_team_profile_page.dart';
import 'package:freegency_gp/Features/settings/presentation/views/edit_user_profile_page.dart';
import 'package:freegency_gp/Features/settings/presentation/views/settings_page.dart';
import 'package:freegency_gp/Features/splash/presentation/views/animated_splash_screen.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/data/repositories/implement_post_job_repo.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/presentation/view_model/cubit/post_job_cubit.dart';
import 'package:freegency_gp/Features/team_scene/Features/post_job/presentation/views/post_job_screen.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/views/task_details_for_team.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/views/post_project_screen.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_profile/presentation/views/web_view_screen.dart';
import 'package:freegency_gp/core/shared/data/repositories/categories_and_services_repositories/implement_categories_and_services_repositories.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String clientHome = '/client-home';
  static const String postTask = '/post-task';
  static const String postProject = '/post-project';
  static const String hireJob = '/hire-job';
  static const String resetPassword = '/reset-password';
  static const String userLogin = '/login';
  static const String teamLogin = '/teamLogin';
  static const String projectInspiration = '/project-inspiration';
  static const String viewAllProposals = '/view-all-proposals';
  static const String viewProposalDetails = '/view-proposal-details';
  static const String taskDetailsForTeam = '/task-details-for-team';
  static const String settings = '/settings';
  static const String appSettings = '/app-settings';
  static const String exploreServicesByCategory =
      '/explore-services-by-category';
  static const String specificTeamProfile = '/specific-team-profile';
  static const String chooseInterests = '/choose-interests';
  static const String editUserProfile = '/edit-user-profile';
  static const String editTeamProfile = '/edit-team-profile';
  static const String webView = '/web-view';
}

Map<String, Widget Function(BuildContext)> routes = {
  AppRoutes.splash: (_) => const AnimatedSplashScreen(),
  AppRoutes.auth: (_) => const MainAuthScreen(),
  AppRoutes.clientHome: (_) => BlocProvider(
        create: (context) => ChangeBtnNavBarCubit(),
        child: const ClientHomePage(),
      ),
  AppRoutes.postTask: (_) => BlocProvider(
        create: (context) =>
            PostTaskFromClientCubit(PostTaskRepoImplementation()),
        child: const PostTaskScreen(),
      ),
  AppRoutes.postProject: (_) => const PostProjectScreen(),
  AppRoutes.resetPassword: (_) => const ResetPasswordScreen(),
  AppRoutes.userLogin: (_) => const ClientLoginScreen(),
  AppRoutes.teamLogin: (_) => const TeamLeaderLoginScreen(),
  AppRoutes.projectInspiration: (_) => const ProjectInspirationPage(),
  AppRoutes.viewAllProposals: (_) => const ViewAllProposalsScreen(),
  AppRoutes.viewProposalDetails: (_) => const ViewProposalDetails(),
  AppRoutes.taskDetailsForTeam: (_) => const TaskDetailsForTeam(),
  AppRoutes.settings: (_) => const SettingsScreen(),
  AppRoutes.appSettings: (_) => const SettingsPage(),
  AppRoutes.editUserProfile: (_) => BlocProvider(
        create: (context) => UserDataFunctionalityCubit(ImplementUserRepo()),
        child: const EditUserProfilePage(),
      ),
  AppRoutes.editTeamProfile: (_) => const EditTeamProfilePage(),
  AppRoutes.exploreServicesByCategory: (_) => BlocProvider(
        create: (context) => ExploringProgectsWithCategoriesAndServicesCubit(
            ImplementedClientHomeRepo()),
        child: const ExplortServicesByCategory(),
      ),
  AppRoutes.specificTeamProfile: (_) => const SpecificTeamProfileScreen(),
  AppRoutes.chooseInterests: (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool editMode = args?['editMode'] ?? false;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChooseInterestsCubit()),
        BlocProvider(
          create: (context) => GetCategoriesAndServicesCubit(
              CategoriesAndServicesRepositoriesImplementation()),
        ),
      ],
      child: ChooseInterestsScreen(editMode: editMode),
    );
  },
  AppRoutes.hireJob: (_) => BlocProvider(
        create: (context) => PostJobCubit(PostJobRepoImplementation()),
        child: const PostJobScreen(),
      ),
  AppRoutes.webView: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return WebViewScreen(
      url: args['url'] as String,
      title: args['title'] as String,
    );
  },
};

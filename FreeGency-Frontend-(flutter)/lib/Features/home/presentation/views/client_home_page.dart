import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/available_jobs/presentation/view_model/available_jobs_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:freegency_gp/Features/client_scene/Features/inbox/presentation/view_model/cubit/notifications_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/repositories/implement_user_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/user_data_functionality_cubit.dart';
import 'package:freegency_gp/Features/home/presentation/view_model/cubits/change_btn_nav_bar/change_btn_nav_bar_cubit.dart';
import 'package:freegency_gp/Features/home/presentation/view_model/cubits/client_home_page/client_home_page_cubit.dart';
import 'package:freegency_gp/Features/home/presentation/widgets/home_screens_builder.dart';
import 'package:freegency_gp/Features/home/presentation/widgets/home_scroll_handler.dart';
import 'package:freegency_gp/core/shared/data/repositories/categories_and_services_repositories/implement_categories_and_services_repositories.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/app_drawer.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/shared/widgets/freegency_app_logo.dart';
import 'package:freegency_gp/core/shared/widgets/keep_alive_indexed_stack.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/utils/constants/routes.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key});

  static const routeName = '/client-home';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientHomePageCubit()..initializeUser(),
      child: const ClientHomePageView(),
    );
  }
}

class ClientHomePageView extends StatelessWidget {
  const ClientHomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHomePageCubit, ClientHomePageState>(
      builder: (context, state) {
        final cubit = context.read<ClientHomePageCubit>();

        if (!cubit.isInitialized) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ClientHomePageError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => cubit.initializeUser(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  UserDataFunctionalityCubit(ImplementUserRepo()),
            ),
            BlocProvider(
              create: (context) => NotificationsCubit(),
            ),
            BlocProvider(
              create: (context) => GetCategoriesAndServicesCubit(
                  CategoriesAndServicesRepositoriesImplementation()),
            ),
            BlocProvider(
              create: (context) => AvailableJobsCubit(),
            ),
          ],
          child: BlocBuilder<ChangeBtnNavBarCubit, ChangeBtnNavBarState>(
            builder: (context, navState) {
              final navCubit = context.read<ChangeBtnNavBarCubit>();
              final currentIndex = navCubit.currentIndex;

              // Mark current screen as visited for lazy loading
              WidgetsBinding.instance.addPostFrameCallback((_) {
                cubit.markScreenAsVisited(currentIndex);
              });

              return HomeScrollHandler(
                cubit: cubit,
                currentIndex: currentIndex,
                child: Scaffold(
                  drawer: const AppDrawer(),
                  appBar: CustomAppBar(
                    child: _buildAppBarTitle(context, currentIndex, cubit),
                  ),
                  body: SafeArea(
                    child: KeepAliveIndexedStack(
                      index: currentIndex,
                      children: _buildScreens(cubit),
                    ),
                  ),
                  floatingActionButton:
                      _buildFloatingActionButton(context, cubit, currentIndex),
                  bottomNavigationBar: CustomBtnNavBar(
                    cubit: navCubit,
                    role: cubit.isClient,
                    isTeamLeader: cubit.isTeamLeader,
                    isTeamMember: cubit.isTeamMember,
                    isGuest: cubit.isGuest,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Builds the app bar title based on current tab index
  Widget _buildAppBarTitle(
      BuildContext context, int currentIndex, ClientHomePageCubit cubit) {
    switch (currentIndex) {
      case 0:
        return FreeGencyLogo(
          color: Theme.of(context).colorScheme.onSurface,
          width: 72,
        );
      case 1:
        return ReusableTextStyleMethods.poppins16BoldMethod(
          context: context,
          text: cubit.isGuest
              ? context.tr('profile')
              : context.tr('notifications'),
        );
      case 2:
        return ReusableTextStyleMethods.poppins16BoldMethod(
          context: context,
          text: context.tr('profile'),
        );
      case 3:
        return ReusableTextStyleMethods.poppins16BoldMethod(
          context: context,
          text: context.tr('available_jobs'),
        );
      case 4:
        return ReusableTextStyleMethods.poppins16BoldMethod(
          context: context,
          text: context.tr('jobs'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  /// Builds the screens list using lazy loading
  List<Widget> _buildScreens(ClientHomePageCubit cubit) {
    return List.generate(
      cubit.totalScreensCount,
      (index) => HomeScreensBuilder(cubit: cubit, index: index),
    );
  }

  /// Builds the floating action button for clients and team leaders
  Widget? _buildFloatingActionButton(
      BuildContext context, ClientHomePageCubit cubit, int currentIndex) {
    // Show FAB for clients and team leaders
    if ((!cubit.isClient && !cubit.isTeamLeader && !cubit.isTeamMember) ||
        !cubit.isFabVisible) {
      return null;
    }

    // For team leaders, show FAB only on jobs page (index 4)
    if (cubit.isTeamLeader && currentIndex != 4) {
      return null;
    }

    // For team members, show FAB only on jobs page (index 4)
    if (cubit.isTeamMember && currentIndex != 4) {
      return null;
    }

    // Determine button text and route based on user type
    final String buttonText =
        cubit.isClient ? context.tr('post_task') : context.tr('post_job');

    final String targetRoute = cubit.isClient || cubit.isTeamMember
        ? AppRoutes.postTask
        : AppRoutes.hireJob;

    return FloatingActionButton.extended(
      heroTag: "main_home_fab",
      onPressed: () {
        Get.toNamed(targetRoute);
      },
      icon: Icon(
        Iconsax.add,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      label: Text(
        buttonText,
        style: AppTextStyles.poppins14Regular(context)!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

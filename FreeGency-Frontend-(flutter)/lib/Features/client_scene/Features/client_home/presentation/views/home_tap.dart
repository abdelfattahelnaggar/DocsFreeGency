import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/client_home_repository/implemented_client_home_repo.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/view_model/home_tap/cubit/client_home_tap_cubit.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/presentation/widgets/home_tap_body.dart';
import 'package:freegency_gp/core/shared/data/repositories/categories_and_services_repositories/implement_categories_and_services_repositories.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/utils/local_storage/local_storage.dart';

class ClientHomeTap extends StatefulWidget {
  const ClientHomeTap({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<ClientHomeTap> createState() => _ClientHomeTapState();
}

class _ClientHomeTapState extends State<ClientHomeTap> {
  bool _isClient = false;
  bool _isGuest = false;
  bool _isTeamMember = false;
  bool _shouldShowContent = false;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    _isClient = await LocalStorage.isClient();
    _isGuest = await LocalStorage.isGuest();
    _isTeamMember = await LocalStorage.isTeamMember();
    _shouldShowContent =
        _isClient || _isGuest || _isTeamMember; // Show content for both client and guest
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowContent) {
      return const Center(
        child: AppLoadingIndicator(),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ClientHomeTapCubit(ImplementedClientHomeRepo()),
        ),
        BlocProvider(
          create: (context) => GetCategoriesAndServicesCubit(
              CategoriesAndServicesRepositoriesImplementation()),
        ),
      ],
      child: HomeTapBody(scrollController: widget.scrollController),
    );
  }
}

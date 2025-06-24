import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/client_home/data/models/teams_model.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

import '../cubit/team_profile_cubit.dart';
import '../cubit/team_profile_state.dart';
import 'widgets/contact_business_section.dart';
import 'widgets/team_account_settings_section.dart';
import 'widgets/team_info_section.dart';
import 'widgets/team_logo_widget.dart';
import 'widgets/team_skills_section.dart';
import 'widgets/team_social_links_section.dart';

class EditTeamProfilePage extends StatefulWidget {
  const EditTeamProfilePage({super.key});

  @override
  State<EditTeamProfilePage> createState() => _EditTeamProfilePageState();
}

class _EditTeamProfilePageState extends State<EditTeamProfilePage> {
  final _teamNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pricingController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final Map<String, TextEditingController> _socialLinkControllers = {};
  bool _controllersPopulated = false;

  @override
  void dispose() {
    _teamNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pricingController.dispose();
    _descriptionController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    for (var controller in _socialLinkControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeamProfileCubit()..loadTeamProfile(),
      child: Scaffold(
        appBar: CustomAppBar(
          isHome: false,
          child: ReusableTextStyleMethods.poppins16BoldMethod(
              context: context, text: context.tr('edit_profile.title_team')),
        ),
        body: BlocConsumer<TeamProfileCubit, TeamProfileState>(
          listener: (context, state) {
            if (state is TeamProfileLoaded && !_controllersPopulated) {
              final profile = state.teamProfile;
              _teamNameController.text = profile.name ?? '';
              _descriptionController.text = profile.about ?? '';
              _emailController.text = profile.contactInfo?['email'] ?? '';
              _phoneController.text = profile.contactInfo?['phone'] ?? '';
              _pricingController.text = '';

              _socialLinkControllers.clear();
              for (var link in profile.socialMediaLinks ?? []) {
                _socialLinkControllers[link['id']] =
                    TextEditingController(text: link['url']);
              }
              _controllersPopulated = true;
            }

            if (state is TeamProfileError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is TeamValidationError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is TeamProfileUpdated) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is TeamPasswordChanged) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(context.tr('password_changed_successfully'))),
              );
              _currentPasswordController.clear();
              _newPasswordController.clear();
              _confirmPasswordController.clear();
            }
          },
          builder: (context, state) {
            final cubit = context.read<TeamProfileCubit>();
            final currentProfile = cubit.inMemoryProfile;

            if (state is TeamProfileInitial ||
                (state is TeamProfileLoading && currentProfile == null)) {
              return const Center(child: CircularProgressIndicator());
            }

            if (currentProfile == null) {
              return Center(child: Text(context.tr('error_loading_profile')));
            }

            return _buildProfileContent(context, currentProfile);
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, TeamsModel currentProfile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          24.height,
          TeamLogoWidget(
            logoUrl: currentProfile.logo ?? '',
            onLogoTap: () => _showImagePicker(context),
          ),
          24.height,
          TeamInfoSection(
            teamNameController: _teamNameController,
            descriptionController: _descriptionController,
          ),
          ContactBusinessSection(
            emailController: _emailController,
            phoneController: _phoneController,
            pricingController: _pricingController,
          ),
          TeamSkillsSection(
            skills: currentProfile.skills ?? [],
          ),
          TeamSocialLinksSection(
            socialLinks: currentProfile.socialMediaLinks ?? [],
            socialLinkControllers: _socialLinkControllers,
            onAddSocialLink: () =>
                context.read<TeamProfileCubit>().addEmptySocialLink(),
          ),
          TeamAccountSettingsSection(
            currentPasswordController: _currentPasswordController,
            newPasswordController: _newPasswordController,
            confirmPasswordController: _confirmPasswordController,
            onChangePassword: () => _changePassword(context),
            onManageTeamMembers: () =>
                context.read<TeamProfileCubit>().navigateToManageTeamMembers(),
            onPaymentMethods: () =>
                context.read<TeamProfileCubit>().navigateToPaymentMethods(),
          ),
          32.height,
          PrimaryCTAButton(
            label: context.tr('edit_profile.save'),
            onTap: () => _saveChanges(context),
            isLoading:
                context.watch<TeamProfileCubit>().state is TeamProfileUpdating,
          ),
          32.height,
        ],
      ),
    );
  }

  void _saveChanges(BuildContext context) {
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    context.read<TeamProfileCubit>().saveTeamProfileChanges(
          teamName: _teamNameController.text.trim(),
          description: _descriptionController.text.trim(),
          email: email.isNotEmpty ? email : null,
          phone: phone.isNotEmpty ? phone : null,
          pricing: _pricingController.text.trim(),
        );
  }

  void _changePassword(BuildContext context) {
    context.read<TeamProfileCubit>().changePassword(
          _currentPasswordController.text,
          _newPasswordController.text,
          _confirmPasswordController.text,
        );
  }

  void _showImagePicker(BuildContext context) {
    context.read<TeamProfileCubit>().updateTeamLogo('path/to/image');
  }
}

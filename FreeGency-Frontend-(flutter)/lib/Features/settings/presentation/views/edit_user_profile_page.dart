import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/user_model.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/presentation/view_model/cubit/user_data_functionality_cubit.dart';
import 'package:freegency_gp/Features/settings/data/models/update_user_profile_request_model.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

import 'widgets/account_settings_section.dart';
import 'widgets/contact_info_section.dart';
import 'widgets/personal_info_section.dart';
import 'widgets/profile_picture_widget.dart';
import 'widgets/skills_section.dart';
import 'widgets/social_links_section.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _facebookController = TextEditingController();
  final _githubController = TextEditingController();
  final _websiteController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserDataFunctionalityCubit>().getUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _linkedinController.dispose();
    _facebookController.dispose();
    _githubController.dispose();
    _websiteController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _populateControllers(UserModel user) {
    _nameController.text = user.name ?? '';
    _bioController.text = user.bio ?? '';
    _emailController.text = user.contactInfo?.email ?? '';
    _phoneController.text = user.contactInfo?.phone ?? '';
    _linkedinController.text = user.socialMediaLinks?.linkedin ?? '';
    _facebookController.text = user.socialMediaLinks?.facebook ?? '';
    _githubController.text = user.socialMediaLinks?.github ?? '';
    _websiteController.text = user.socialMediaLinks?.website ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isHome: false,
        child: ReusableTextStyleMethods.poppins16BoldMethod(
            context: context, text: context.tr('edit_profile.title')),
      ),
      body:
          BlocConsumer<UserDataFunctionalityCubit, UserDataFunctionalityState>(
        listener: (context, state) {
          if (state is GetUserDataError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          } else if (state is UpdateUserDataSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(context.tr('profile_updated_successfully'))),
            );
          } else if (state is UpdateUserDataError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          } else if (state is PasswordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(context.tr('password_changed_successfully'))),
            );
          } else if (state is PasswordChangeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is GetUserDataLoading ||
              state is UserDataFunctionalityInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetUserDataSuccess) {
            _populateControllers(state.userModel);
            return _buildProfileContent(context, state.userModel);
          }
          if (state is UpdateUserDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UpdateUserDataSuccess) {
            return _buildProfileContent(context, state.userModel);
          }

          if (context.read<UserDataFunctionalityCubit>().cachedUserData !=
              null) {
            return _buildProfileContent(context,
                context.read<UserDataFunctionalityCubit>().cachedUserData!);
          }

          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          24.height,
          ProfilePictureWidget(
            imageUrl: user.image ?? '',
            onImageTap: () => _showImagePicker(context),
            isUpdating: context.watch<UserDataFunctionalityCubit>().state
                is UploadImageLoading,
          ),
          24.height,
          PersonalInfoSection(
            nameController: _nameController,
            bioController: _bioController,
          ),
          ContactInfoSection(
            emailController: _emailController,
            phoneController: _phoneController,
          ),
          SkillsSection(
            skills: user.skills,
          ),
          SocialLinksSection(
            linkedinController: _linkedinController,
            githubController: _githubController,
            facebookController: _facebookController,
            websiteController: _websiteController,
          ),
          AccountSettingsSection(
            currentPasswordController: _currentPasswordController,
            newPasswordController: _newPasswordController,
            confirmPasswordController: _confirmPasswordController,
            onChangePassword: () => _changePassword(context),
          ),
          32.height,
          PrimaryCTAButton(
            label: context.tr('edit_profile.save'),
            onTap: () => _saveProfile(context),
            isLoading: context.watch<UserDataFunctionalityCubit>().state
                is UpdateUserDataLoading,
          ),
          32.height,
        ],
      ),
    );
  }

  void _saveProfile(BuildContext context) {
    final request = UpdateUserProfileRequestModel(
      name: _nameController.text,
      bio: _bioController.text,
      contactInfo: ContactInfoModel(
        email: _emailController.text,
        phone: _phoneController.text,
      ),
      socialMediaLinks: SocialMediaLinksModel(
        linkedin: _linkedinController.text,
        facebook: _facebookController.text,
        github: _githubController.text,
        website: _websiteController.text,
      ),
      skills:
          context.read<UserDataFunctionalityCubit>().cachedUserData?.skills ??
              [],
    );
    context.read<UserDataFunctionalityCubit>().updateUser(request);
  }

  void _changePassword(BuildContext context) {
    context.read<UserDataFunctionalityCubit>().changePassword(
          _currentPasswordController.text,
          _newPasswordController.text,
        );
  }

  void _showImagePicker(BuildContext context) {
    // TODO: Implement image picker
  }
}

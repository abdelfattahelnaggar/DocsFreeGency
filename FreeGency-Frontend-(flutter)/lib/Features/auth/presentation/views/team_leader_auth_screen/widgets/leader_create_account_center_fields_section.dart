import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/generate_account_random_code_for_team.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/password_checklist.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/team_code_input_field.dart';
import 'package:freegency_gp/core/shared/data/models/categories_and_its_services_model.dart';
import 'package:freegency_gp/core/shared/data/repositories/categories_and_services_repositories/implement_categories_and_services_repositories.dart';
import 'package:freegency_gp/core/shared/view_model/get_categories_and_services_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/custom_text_field.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';
import 'package:iconsax/iconsax.dart';

class LeaderCreateAccountCenterFieldsSection extends StatefulWidget {
  const LeaderCreateAccountCenterFieldsSection({super.key});

  @override
  State<LeaderCreateAccountCenterFieldsSection> createState() =>
      _LeaderCreateAccountCenterFieldsSectionState();
}

class _LeaderCreateAccountCenterFieldsSectionState
    extends State<LeaderCreateAccountCenterFieldsSection> {
  String? selectedCategoryId;
  List<CategoryModel>? categories;
  bool hasLoaded = false;

  void _loadCategoriesIfNeeded(BuildContext context) {
    if (!hasLoaded) {
      context.read<GetCategoriesAndServicesCubit>().fetchCategories();
      hasLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    return BlocProvider(
      create: (context) => GetCategoriesAndServicesCubit(
          CategoriesAndServicesRepositoriesImplementation()),
      child: Column(
        spacing: 16,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: validationCubit.nameController,
                  label: context.tr('team_name'),
                  prefixIcon: Iconsax.activity,
                ),
              ),
              Flexible(
                child: BlocBuilder<GetCategoriesAndServicesCubit,
                    GetCategoriesAndServicesState>(
                  builder: (context, state) {
                    List<DropdownMenuItem<String>> dropdownItems = [];

                    if (state is GetCategoriesAndServicesSuccess) {
                      dropdownItems =
                          (state.data as List<CategoryModel>).map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat.id,
                          child: Text(
                            cat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.poppins14Regular(context)!
                                .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        );
                      }).toList();
                    }

                    return GestureDetector(
                      onTap: () => _loadCategoriesIfNeeded(context),
                      child: AbsorbPointer(
                        absorbing: state is GetCategoriesAndServicesLoading,
                        child: DropdownButtonFormField<String>(
                          value: selectedCategoryId,
                          isExpanded: true,
                          icon: const Icon(Iconsax.arrow_down_1, size: 18),
                          style: AppTextStyles.poppins14Regular(context),
                          decoration: InputDecoration(
                            hintText: state is GetCategoriesAndServicesLoading
                                ? context.tr('loading_categories')
                                : state is GetCategoriesAndServicesError
                                    ? context.tr('error')
                                    : context.tr('select_category'),
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            hintStyle: AppTextStyles.poppins12Regular(context),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: dropdownItems,
                          onChanged: (value) {
                            setState(() {
                              selectedCategoryId = value;
                              validationCubit.teamCategoryController.text =
                                  value ?? '';
                            });
                          },
                          validator: (value) => value == null
                              ? context.tr('please_select_category')
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          CustomTextField(
            controller: validationCubit.emailController,
            label: context.tr('email'),
            validationType: TextFieldValidation.EMAIL,
          ),
          CustomTextField(
            controller: validationCubit.passwordController,
            label: context.tr('password'),
            isPassword: true,
            validationType: TextFieldValidation.PASSWORD,
            onChanged: (password) {
              validationCubit.onPasswordChanged(password);
            },
          ),
          const PasswordChecklist(),
          const GenerateRandomCodeRow(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: const TeamCodeInputField(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/client_scene/Features/post_task/presentation/widgets/custom_text_field.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/views/create_proposal_screen.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/widgets/upload_proposal_file.dart';
import 'package:freegency_gp/core/shared/view_model/proposal_functionality/cubit/proposal_functionality_cubit.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/shared/widgets/custom_app_bar.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';
import 'package:freegency_gp/core/utils/helpers/text_styles.dart';

class CreateProposalBody extends StatelessWidget {
  const CreateProposalBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.widget,
    required this.isFixedPrice,
    required TextEditingController noteController,
    required TextEditingController budgetController,
    required TextEditingController similarProjectUrlController,
  })  : _formKey = formKey,
        _noteController = noteController,
        _budgetController = budgetController,
        _similarProjectUrlController = similarProjectUrlController;

  final GlobalKey<FormState> _formKey;
  final CreateProposalScreen widget;
  final bool isFixedPrice;
  final TextEditingController _noteController;
  final TextEditingController _budgetController;
  final TextEditingController _similarProjectUrlController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProposalFunctionalityCubit, ProposalFunctionalityState>(
      listener: (context, state) {
        if (state is SubmitProposalSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proposal sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }

        if (state is SubmitProposalError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state is SubmitProposalLoading;

        return Scaffold(
          appBar: CustomAppBar(
            isHome: false,
            child: ReusableTextStyleMethods.poppins16BoldMethod(
              context: context,
              text: 'Apply Task',
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableTextStyleMethods.poppins16BoldMethod(
                      context: context,
                      text: 'Task Title: ${widget.task.title}',
                    ),
                    8.height,
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isFixedPrice ? Icons.lock : Icons.sync_alt,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20.r,
                          ),
                          8.width,
                          Expanded(
                            child: Text(
                              isFixedPrice
                                  ? 'This task has a fixed budget of ${widget.task.budget}. You cannot modify this amount.'
                                  : 'This task has a flexible budget. You can propose your own budget.',
                              style: AppTextStyles.poppins14Regular(context)!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    24.height,
                    ReusableTextStyleMethods.poppins14RegularMethod(
                      context: context,
                      text: 'Proposal Note',
                    ),
                    8.height,
                    CustomTextField(
                      controller: _noteController,
                      hintText: 'Write your proposal details...',
                      maxLines: 6,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter proposal details';
                        }
                        return null;
                      },
                    ),
                    16.height,
                    ReusableTextStyleMethods.poppins14RegularMethod(
                      context: context,
                      text: isFixedPrice
                          ? 'Client Budget (Fixed)'
                          : 'Your Budget',
                    ),
                    8.height,
                    CustomTextField(
                      controller: _budgetController,
                      hintText: isFixedPrice
                          ? 'Fixed budget by client'
                          : 'Enter your budget',
                      textInputType: TextInputType.number,
                      readOnly: isFixedPrice,
                      prefixIcon: Icons.attach_money,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your budget';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    16.height,
                    ReusableTextStyleMethods.poppins14RegularMethod(
                      context: context,
                      text: 'Similar Project URL (Optional)',
                    ),
                    8.height,
                    CustomTextField(
                      controller: _similarProjectUrlController,
                      hintText: 'https://example.com',
                      textInputType: TextInputType.url,
                      prefixIcon: Icons.link,
                    ),
                    24.height,
                    ReusableTextStyleMethods.poppins14RegularMethod(
                      context: context,
                      text: 'Upload Related Files',
                    ),
                    8.height,
                    const UploadProposalFile(),
                    32.height,
                    PrimaryCTAButton(
                      label: "Submit Proposal",
                      onTap: isSubmitting
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final proposalCubit =
                                    context.read<ProposalFunctionalityCubit>();
                                proposalCubit.submitProposal(
                                  taskId: widget.task.id!,
                                  note: _noteController.text,
                                  budget: int.parse(_budgetController.text),
                                  similarProjectUrl:
                                      _similarProjectUrlController
                                              .text.isNotEmpty
                                          ? _similarProjectUrlController.text
                                          : null,
                                );
                              }
                            },
                      child: isSubmitting ? const AppLoadingIndicator() : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

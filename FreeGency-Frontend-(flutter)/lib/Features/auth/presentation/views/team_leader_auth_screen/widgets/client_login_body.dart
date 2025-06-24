import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/auth_page_footer.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/center_field_section.dart';
import 'package:freegency_gp/Features/auth/presentation/widgets/top_welcome_message.dart';

class TeamLeaderScreenBody extends StatelessWidget {
  const TeamLeaderScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ValidationCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: cubit.myForm,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              reverse: true,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  spacing: 40,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TopWelcomeMessage(
                      largeText: 'Welcome Back!',
                      descriptionText:
                          'Join as a Client and find the perfect team for your next big idea!\nSign up to connect with top agencies and teams ready to bring your vision to life..',
                    ),
                    const CenterFieldsSection(),
                    AuthPageFooter(onLoginPressed: () {
                      cubit.validateForm();
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

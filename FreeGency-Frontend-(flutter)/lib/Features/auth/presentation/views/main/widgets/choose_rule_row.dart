import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/selected_rule_cubit/selected_rule_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/client_auth_screen/views/client_login_auth_screen.dart';
import 'package:freegency_gp/Features/auth/presentation/views/main/widgets/choose_rule_box.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/views/team_leader_login_screen.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart';

class ChooseRuleRow extends StatelessWidget {
  const ChooseRuleRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectedRuleCubit>();
    return BlocListener<SelectedRuleCubit, SelectedRuleState>(
      listener: (context, state) {
        if (state is ClientRuleSelectedState) {
          Get.to(const ClientLoginScreen(),
              transition: getx.Transition.downToUp);
        } else if (state is TeamLeaderRuleSelectedState) {
          Get.to(const TeamLeaderLoginScreen(),
              transition: getx.Transition.downToUp);
        }
      },
      child: Row(
        spacing: 16,
        children: List.generate(
          cubit.guestRules.length,
          (index) => ChooseRuleBox(
            onTap: () => cubit.updateSelectedRule(index),
            guestModel: cubit.guestRules[index],
          ),
        ),
      ),
    );
  }
}

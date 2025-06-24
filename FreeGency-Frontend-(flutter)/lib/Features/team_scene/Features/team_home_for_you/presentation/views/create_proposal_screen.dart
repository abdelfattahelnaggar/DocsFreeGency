import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freegency_gp/Features/client_scene/Features/profile/data/models/task_model.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/widgets/create_proposal_body.dart';
import 'package:freegency_gp/core/shared/data/repositories/proposal_repo/implemented_proposal_repo.dart';
import 'package:freegency_gp/core/shared/view_model/proposal_functionality/cubit/proposal_functionality_cubit.dart';

class CreateProposalScreen extends StatefulWidget {
  final TaskModel task;

  const CreateProposalScreen({super.key, required this.task});

  @override
  State<CreateProposalScreen> createState() => _CreateProposalScreenState();
}

class _CreateProposalScreenState extends State<CreateProposalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _similarProjectUrlController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task.isFixedPrice == true && widget.task.budget != null) {
      _budgetController.text = widget.task.budget.toString();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _budgetController.dispose();
    _similarProjectUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if task has fixed price
    final bool isFixedPrice = widget.task.isFixedPrice == true;

    return BlocProvider(
      create: (context) =>
          ProposalFunctionalityCubit(ImplementedProposalRepository()),
      child: CreateProposalBody(
          formKey: _formKey,
          widget: widget,
          isFixedPrice: isFixedPrice,
          noteController: _noteController,
          budgetController: _budgetController,
          similarProjectUrlController: _similarProjectUrlController),
    );
  }
}

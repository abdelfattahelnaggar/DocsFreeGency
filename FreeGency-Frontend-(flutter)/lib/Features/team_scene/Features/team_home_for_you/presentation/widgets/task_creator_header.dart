import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/data/repositories/implement_team_home_repo.dart';
import 'package:freegency_gp/Features/team_scene/Features/team_home_for_you/presentation/view_model/cubit/my_team_functionality_cubit_cubit.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class TaskCreatorHeader extends StatefulWidget {
  final String? imageUrl;
  final String? name;
  final String? taskId;

  const TaskCreatorHeader({
    super.key,
    this.imageUrl,
    this.name,
    this.taskId,
  });

  @override
  State<TaskCreatorHeader> createState() => _TaskCreatorHeaderState();
}

class _TaskCreatorHeaderState extends State<TaskCreatorHeader> {
  late MyTeamFunctionalityCubitCubit _cubit;
  bool _isCubitProvided = false;

  @override
  void initState() {
    super.initState();
    _initCubit();
  }

  void _initCubit() {
    try {
      _cubit = BlocProvider.of<MyTeamFunctionalityCubitCubit>(context);
      _isCubitProvided = true;
    } catch (e) {
      _cubit = MyTeamFunctionalityCubitCubit(
        teamHomeRepo: TeamHomeRepoImplementation(),
      );
      _isCubitProvided = false;
      _cubit.getSavedTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCubitProvided) {
      return BlocProvider.value(
        value: _cubit,
        child: _buildContent(context),
      );
    }
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl ??
                  'https://tse2.mm.bing.net/th?id=OIP.PZsMLTIgXaEsdCA0VjTo7gHaLH&rs=1&pid=ImgDetMain',
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 50.w,
              height: 50.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        16.width,
        ReusableTextStyleMethods.poppins16BoldMethod(
          context: context,
          text: widget.name ?? "No Name",
        ),
        const Spacer(),
        BlocConsumer<MyTeamFunctionalityCubitCubit,
            MyTeamFunctionalityCubitState>(
          listener: (context, state) {
            if (state is SavingTaskSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(8.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            }
            if (state is SavingTaskError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(8.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final isSaved =
                widget.taskId != null && _cubit.isTaskSaved(widget.taskId!);
            if (state is SavingTaskLoading) {
              return const CircularProgressIndicator();
            }
            return IconButton(
              onPressed: widget.taskId == null
                  ? null
                  : () {
                      if (isSaved) {
                        _cubit.unsaveTask(widget.taskId!);
                      } else {
                        _cubit.saveTask(widget.taskId!);
                      }
                    },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 50),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey<bool>(isSaved),
                  color: isSaved
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

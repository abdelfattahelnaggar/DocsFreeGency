import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/auth_cubit/user_auth_cubit/user_auth_state.dart';
import 'package:freegency_gp/Features/auth/presentation/view_model/cubits/validation_cubit/validation_cubit.dart';
import 'package:freegency_gp/Features/auth/presentation/views/client_auth_screen/views/client_register_auth_screen.dart';
import 'package:freegency_gp/Features/auth/presentation/views/client_auth_screen/widgets/login_methods_row.dart';
import 'package:freegency_gp/Features/auth/presentation/views/team_leader_auth_screen/widgets/reusable_text_button.dart';
import 'package:freegency_gp/core/shared/widgets/app_loading_indicator.dart';
import 'package:freegency_gp/core/shared/widgets/call_to_action_button.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/helpers/reusable_text_style_methods.dart';
import 'package:freegency_gp/core/utils/helpers/sized_box.dart';

class ClientAuthFooter extends StatelessWidget {
  ClientAuthFooter({
    super.key,
    this.isLogin = true,
    this.onLoginPressed,
    this.awesomeLoginDialog,
  });

  final bool isLogin;
  final VoidCallback? onLoginPressed;
  AwesomeDialog? awesomeLoginDialog;

  @override
  Widget build(BuildContext context) {
    final validateCubit = context.read<ValidationCubit>();
    return Column(
      spacing: 24,
      children: [
        BlocListener<UserAuthCubit, UserAuthStates>(
          listener: (context, state) {
            awesomeLoginDialog?.dismiss();
            if (state is UserAuthLoading) {
              awesomeLoginDialog = AwesomeDialog(
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                dialogBackgroundColor: AppBarTheme.of(context).backgroundColor,
                context: context,
                dialogType: DialogType.noHeader,
                animType: AnimType.topSlide,
                title: context.tr('loading'),
                btnOk: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: const Center(
                    child: AppLoadingIndicator(size: 30),
                  ),
                ),
              )..show();
            } else if (state is UserAuthSuccess) {
              awesomeLoginDialog?.dismiss();
              awesomeLoginDialog = AwesomeDialog(
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                dialogBackgroundColor: AppBarTheme.of(context).backgroundColor,
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.topSlide,
                btnOkColor: Theme.of(context).colorScheme.primary,
                btnOkOnPress: () async {
                  awesomeLoginDialog?.dismiss();
                  
                  final routeName = state.nextRoute ?? 
                      (isLogin ? AppRoutes.clientHome : AppRoutes.userLogin);
                      
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    routeName,
                    (route) => false,
                  );
                },
              )..show();
            } else if (state is UserAuthError) {
              awesomeLoginDialog = AwesomeDialog(
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                dialogBackgroundColor: AppBarTheme.of(context).backgroundColor,
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.topSlide,
                title: state.errorMessage,
                titleTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
                btnOkColor: Theme.of(context).colorScheme.primary,
                btnOkOnPress: () {
                  awesomeLoginDialog?.dismiss();
                  Navigator.of(context).pop();
                },
              )..show();
            }
          },
          child: PrimaryCTAButton(
            onTap: onLoginPressed,
            label: isLogin ? context.tr('login') : context.tr('register'),
          ),
        ),
        const LoginMethodsRow(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableTextStyleMethods.poppins12RegularMethod(
                context: context,
                text: isLogin
                    ? context.tr('dont_have_account')
                    : context.tr('already_have_account')),
            Column(
              children: [
                ReusableTextButton(
                  onTap: () {
                    if (isLogin) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ClientRegisterAuthScreen(),
                        ),
                      ).then((value) {
                        validateCubit.myForm.currentState?.reset();
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  text: isLogin ? context.tr('register') : context.tr('login'),
                ),
              ],
            ),
          ],
        ),
        16.height
      ],
    );
  }
}

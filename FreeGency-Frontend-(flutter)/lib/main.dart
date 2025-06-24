import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freegency_gp/core/Themes/dark_theme.dart';
import 'package:freegency_gp/core/Themes/light_theme.dart';
import 'package:freegency_gp/core/shared/view_model/font_cubit/font_cubit.dart';
import 'package:freegency_gp/core/utils/bloc_observer.dart';
import 'package:freegency_gp/core/utils/constants/routes.dart';
import 'package:freegency_gp/core/utils/services/api_service.dart';
import 'package:freegency_gp/core/utils/services/fcm_services.dart';               
import 'package:get/get.dart';

void main() async {
  ApiService.dioInit();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  await FCMServices().initNotification();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  bloc.Bloc.observer = AppBlocObserver();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: FreeGency(
        savedThemeMode: savedThemeMode,
      ),
    ),
  );
}

class FreeGency extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const FreeGency({super.key, this.savedThemeMode});

  @override
  State<FreeGency> createState() => _FreeGencyState();
}

class _FreeGencyState extends State<FreeGency> {
  late final FontCubit _fontCubit;

  @override
  void initState() {
    super.initState();
    _fontCubit = FontCubit();
  }

  @override
  void dispose() {
    _fontCubit.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = EasyLocalization.of(context)!.locale;
    _fontCubit.updateFont(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      child: bloc.MultiBlocProvider(
        providers: [
          // bloc.BlocProvider(
          //   create: (context) => GetCategoriesAndServicesCubit(
          //       CategoriesAndServicesRepositoriesImplementation()),
          // ),
          bloc.BlocProvider.value(
            value: _fontCubit,
          ),
        ],
        child: bloc.BlocBuilder<FontCubit, TextTheme>(
          builder: (context, textTheme) {
            return AdaptiveTheme(
              light: getLightTheme(textTheme),
              dark: getDarkTheme(textTheme),
              initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
              builder: (theme, darkTheme) => GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'FreeGency',
                theme: theme,
                darkTheme: darkTheme,
                defaultTransition: Transition.rightToLeft,
                routes: routes,
                initialRoute: AppRoutes.splash,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
              ),
              debugShowFloatingThemeButton: true,
            );
          },
        ),
      ),
    );
  }
}

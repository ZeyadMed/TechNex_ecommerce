import 'package:e_commerce/core/cache_manager/cache_manager.dart';
import 'package:e_commerce/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:e_commerce/core/config/brand/brand_config.dart';
import 'package:e_commerce/core/internet_connenction/internet_connection_state.dart';
import 'package:e_commerce/core/internet_connenction/internet_connenction_cubit.dart';
import 'package:e_commerce/core/router/app_router.dart';
import 'package:e_commerce/core/service_locator/service_locator.dart';
import 'package:e_commerce/core/style/assets.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/theme/theme.dart';
import 'package:e_commerce/core/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui' as ui;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'navigatorKey-${DateTime.now().millisecondsSinceEpoch}');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  // options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await FirebaseMessaging.instance.requestPermission();
  // MessagingConfig.initFirebaseMessaging();
  // FirebaseMessaging.onBackgroundMessage(MessagingConfig.messageHandler);
  await CacheManager.init();
  // await CacheManager.fetchAndSaveFcmToken();
  EasyLocalization.ensureInitialized();
  await DI.execute();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
        ],
        path: 'assets/translations',
        // ignore: deprecated_member_use
        fallbackLocale: const Locale('ar'),
        useFallbackTranslations: true,
        useFallbackTranslationsForEmptyResources: true,
        saveLocale: true,
        useOnlyLangCode: true,
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Directionality(
              textDirection: context.locale.languageCode == 'ar'
                  ? ui.TextDirection.rtl
                  : ui.TextDirection.ltr,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => InternetCubit()),
                  BlocProvider.value(value: getIt<ThemeBloc>()),
                ],
                child: BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    return BlocBuilder<InternetCubit, InternetState>(
                      builder: (context, state) {
                        final bool offline = state is InternetOffState;
                        return MaterialApp.router(
                          title: BrandConfig.current.appName,
                          debugShowCheckedModeBanner: false,
                          scaffoldMessengerKey: scaffoldMessengerKey,
                          localizationsDelegates: context.localizationDelegates,
                          supportedLocales: context.supportedLocales,
                          locale: context.locale,
                          theme: AppThemeData.light(context),
                          darkTheme: AppThemeData.dark(context),
                          themeMode: themeState.themeMode,
                          routerConfig: AppRouter.router,
                          builder: (context, child) {
                            final media = MediaQuery.of(context)
                                .copyWith(textScaler: TextScaler.noScaling);
                            if (offline) {
                              return MediaQuery(
                                data: media,
                                child: Scaffold(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  body: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Lottie.asset(
                                          Assets.assetsSvgNoInternet,
                                          height: 200.h,
                                        ),
                                      ),
                                      Gaps.h18(),
                                      Center(
                                        child: Text(
                                          "noInternet".tr(),
                                          style: TextStyles.blackBold14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return MediaQuery(data: media, child: child!);
                          },
                        );
                      },
                    );
                  },
                ),
              ));
        });
  }
}

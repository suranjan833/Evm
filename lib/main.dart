import 'dart:async';

import 'package:emv/providers/locale_provider.dart';
import 'package:emv/services/push_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_value/shared_value.dart';

import 'app_config.dart';
import 'emv/commons/stylesheet.dart';
import 'emv/handlers/data_handler.dart';
import 'emv/handlers/filter_handler.dart';
import 'emv/splash.dart';
import 'lang_config.dart';
import 'my_theme.dart';
import 'other_config.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // AddonsHelper().setAddonsData();
  // BusinessSettingHelper().setBusinessSettingData();
  // app_language.load();
  // app_mobile_language.load();
  // app_language_rtl.load();
  //
  // access_token.load().whenComplete(() {
  //   AuthHelper().fetch_and_set();
  // });

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      Firebase.initializeApp().then((value) {
        if (OtherConfig.USE_PUSH_NOTIFICATION) {
          Future.delayed(Duration(milliseconds: 10), () async {
            PushNotificationService().initialise();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (context) => FilterHandler()),
          ChangeNotifierProvider(create: (context) => AppDataHandler()),
        ],
        child: Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
          return MaterialApp(
            builder: OneContext().builder,
            navigatorKey: OneContext().navigator.key,
            title: AppConfig.app_name,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: MyTheme.white,
              scaffoldBackgroundColor: MyTheme.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              /*textTheme: TextTheme(
              bodyText1: TextStyle(),
              bodyText2: TextStyle(fontSize: 12.0),
            )*/
              //
              // the below code is getting fonts from http
              textTheme: GoogleFonts.publicSansTextTheme(textTheme).copyWith(
                displayLarge: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: kBlackColor),
                displayMedium: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: kBlackColor),
                displaySmall: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: kBlackColor),
                headlineMedium: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: kBlackColor),
                headlineSmall: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kBlackColor),
                bodyLarge:
                    GoogleFonts.publicSans(textStyle: textTheme.bodyLarge),
                bodyMedium: GoogleFonts.publicSans(
                    textStyle: textTheme.bodyMedium, fontSize: 12),
              ),
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: MyTheme.accent_color),
            ),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            locale: provider.locale,
            supportedLocales: LangConfig().supportedLocales(),
            home: SplashView(),
            // home: Splash(),
          );
        }));
  }
}

import 'package:emv/emv/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commons/stylesheet.dart';
import 'handlers/data_handler.dart';
import 'handlers/filter_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FilterHandler()),
        ChangeNotifierProvider(create: (context) => AppDataHandler()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: kBlackColor),
          displayMedium: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: kBlackColor),
          displaySmall: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kBlackColor),
          headlineMedium: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: kBlackColor),
          headlineSmall: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: kBlackColor),
        )),
        home: const SplashView(),
      ),
    );
  }
}

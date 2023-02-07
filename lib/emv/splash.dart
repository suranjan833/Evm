import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emv/emv/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_config.dart';
import 'commons/helper_functions.dart';
import 'commons/stylesheet.dart';
import 'handlers/data_handler.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    initConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Center(
        child: Image.asset(appLogo),
      ),
    );
  }

  startSession() async {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    await db.fetchForums();
    await db.fetchUserProfile();
    await db.getLatestUpdates();
    pushAndRemove(
        context,
        DashboardScreen(
          viewIndex: 0,
        ));
  }

  Future<void> initConnectivity() async {
    var event = await _connectivity.checkConnectivity();
    updateConnection(event);
  }

  updateConnection(ConnectivityResult event) {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    bool status = event == ConnectivityResult.none ? false : true;
    db.updateConnection(status);
    startSession();
  }
}

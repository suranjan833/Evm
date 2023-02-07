import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emv/emv/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../app_config.dart';
import '../commons/helper_functions.dart';
import '../commons/icons_logo_strings.dart';
import '../commons/stylesheet.dart';
import '../commons/toast.dart';
import '../handlers/data_handler.dart';
import '../models/tab_button_model.dart';
import 'auth/login.dart';
import 'drawer/drawer_screen.dart';
import 'explore/explore.dart';

class DashboardScreen extends StatefulWidget {
  int viewIndex;
  DashboardScreen({Key key, this.viewIndex = 0}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  int pageIndex = 0;
  Timer _timer;
  final List<BottomBarModel> _bottomBarItems = [
    // BottomBarModel(carIcon, "Used Car"),
    // BottomBarModel(shopNowIcon, "Shop Now"),
    BottomBarModel(homeIcon, "Home"),
    BottomBarModel(userIcon, "My Account"),
  ];
  final List<Widget> _screenView = [
    // const DummyviewScreen(),
    // const ShopNowview(),
    const ExploreViewScreen(),
    const ProfileViewScreen()
  ];

  final bool _fatchingStock = false;

  String news =
      'Elon Musk has terminated the \$44 billion Twitter takeover deal, and the matter is now in a US court, over the presence of bots on the platform, and seeks answers from Agrawal via an open debate.';

  @override
  void initState() {
    initConnectivity();
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      event == ConnectivityResult.none
          ? toast(
              "No Internet Connection. Please turn on your mobile data or connect to wifi")
          : null;
      updateConnection(event);
    });
    setView();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) => getStocks());
  }

  Future<void> initConnectivity() async {
    var event = await _connectivity.checkConnectivity();
    updateConnection(event);
  }

  updateConnection(ConnectivityResult event) {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    bool status = event == ConnectivityResult.none ? false : true;
    db.updateConnection(status);
  }

  getStocks() async {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    await db.fatchStocks();
  }

  setView() => setState(() => pageIndex = widget.viewIndex);
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kBlackColor,
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: Image.asset(
          appLogo,
          height: getAppbarHeight(context) - 10,
        ),
        centerTitle: true,
        actions: [
          Consumer<AppDataHandler>(builder: (context, data, _) {
            final stocks = data.getStocks;
            bool increase = !stocks.regularchange.startsWith("-");
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: _fatchingStock
                  ? Center(
                      child: Image.asset("assets/emv_assets/loading.gif"),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              tesla_logo,
                              height: 15,
                            ),
                            Icon(
                              increase
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 10,
                              color: increase ? kGreenColor : Colors.red,
                            ),
                            Text(
                              " USD ${stocks.marketPrice}",
                              style: const TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                        Text(
                          "${stocks.regularchange} (${stocks.changePercent})",
                          style: TextStyle(
                              fontSize: 10,
                              color: increase ? kGreenColor : Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
            );
          })
        ],
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    decoration: BoxDecoration(
                        color: Color(0xff16213E),
                        border: Border.all(color: Color(0xff16213E))),
                    child: Center(
                      child: Text("LATEST UPDATES",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: kredColor, width: 1.5)),
                        child: Marquee(
                          text: db.getLatestUpdate.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 30.0,
                          // pauseAfterRound: Duration(seconds: 1),
                          startPadding: 10.0,
                          accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        )),
                  ),
                ],
              ),
            ),
            preferredSize: Size(getScreenWidth(context), 40)),
      ),
      drawer: const Drawer(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.horizontal(right: Radius.circular(20))),
          backgroundColor: kWhiteColor,
          child: DrawerScreen()),
      body: _screenView[pageIndex],
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
            backgroundColor: kWhiteColor,
            type: BottomNavigationBarType.shifting,
            unselectedFontSize: 0,
            selectedFontSize: 0,
            currentIndex: pageIndex,
            onTap: (v) {
              print("Tap " + v.toString());
              // v == 1
              //     ? pushTo(context, Main())
              //     :
              (v == 1 && prefs.getString("authToken") == null)
                  ? pushTo(context, LoginScreen())
                  : v == 0
                      ? startSession()
                      : null;
              setState(() => pageIndex = v);
            },
            items: _bottomBarItems
                .map((e) => BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      e.icon,
                      color: kDefaultColor,
                      height: 18,
                      width: 13,
                    ),
                    activeIcon: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kDefaultColor),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        // color: kDefaultColor,
                        child: TextButton.icon(
                            onPressed: null,
                            icon: SvgPicture.asset(
                              e.icon,
                              color: kWhiteColor,
                              width: pageIndex == 1 ? 12 : 20,
                            ),
                            label: Text(
                              e.label,
                              style: theme.headlineSmall
                                  .copyWith(color: kWhiteColor),
                            )),
                      ),
                    ),
                    label: ''))
                .toList()),
      ),
    );
  }

  startSession() async {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    db.newsType = '1';
    db.subnewcount = 1;
    db.newsModel = "All";
    db.newcount = -1;
    await db.fatchLatestNews();
    pushAndRemove(
        context,
        DashboardScreen(
          viewIndex: 0,
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }
}

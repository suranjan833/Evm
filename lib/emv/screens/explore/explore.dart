import 'package:emv/emv/screens/explore/spacex_activity/spacex.dart';
import 'package:emv/emv/screens/explore/tesla_activity/tesla_activity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/custom_tab_button.dart';
import '../../commons/helper_functions.dart';
import '../../commons/icons_logo_strings.dart';
import '../../commons/stylesheet.dart';
import '../../handlers/data_handler.dart';
import '../../models/tab_button_model.dart';
import 'alon_musk_activity/alon_musk.dart';

class ExploreViewScreen extends StatefulWidget {
  const ExploreViewScreen({Key key}) : super(key: key);

  @override
  State<ExploreViewScreen> createState() => _ExploreViewScreenState();
}

class _ExploreViewScreenState extends State<ExploreViewScreen> {
  int tabIndex = 0;
  bool _loading = false;
  final List<TabButtonModel> _tabBar = [
    TabButtonModel(tesla_logo, kredColor),
    TabButtonModel(spaceX_logo, spaceXColor),
    // TabButtonModel(twitter_logo, kcyanColor),
    TabButtonModel(alon_muskLogo, elonMuskColo),
  ];
  final List<Widget> _tabViewScreens = [
    const TeslaActivityScreen(),
    const SpaceXActivityScreen(),
    // const TwitterActivityScreen(),
    const AlonMuskActivityScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final theme = Theme.of(context).textTheme;
    return SizedBox(
      height: getScreenHeight(context),
      width: getScreenWidth(context),
      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: getScreenWidth(context),
                child: Row(
                    children: _tabBar
                        .map((e) => CustomTabButton(
                            isActive: tabIndex == _tabBar.indexOf(e),
                            onTap: () async {
                              setState(() => _loading = true);
                              db.setColorTheme(kDefaultColor);
                              db.setNewsModel("All");
                              setState(() => tabIndex = _tabBar.indexOf(e));
                              db.setNewsType("${_tabBar.indexOf(e) + 1}");
                              await db.fatchLatestNews().then(
                                  (value) => setState(() => _loading = false));
                            },
                            path: e.child,
                            buttonColor: e.buttonColor))
                        .toList()),
              ),
              putHeight(2),
              Container(
                height: 1.5,
                width: getScreenWidth(context),
                color: getIndicatorColour(),
              )
            ],
          ),
          _loading
              ? const Expanded(
                  child: SizedBox(
                      child: Center(child: CircularProgressIndicator())),
                )
              :
              // tabIndex != null
              //     ?
              _tabViewScreens[tabIndex]
          // : const TeslaActivity2Screen()
        ],
      ),
    );
  }

  Color getIndicatorColour() {
    switch (tabIndex) {
      case 0:
        return kredColor;
      case 1:
        return kDefaultColor;
      case 2:
        return kcyanColor;

      default:
        return kDefaultColor;
    }
  }
}

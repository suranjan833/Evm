// ignore_for_file: deprecated_member_use

import 'package:emv/emv/screens/explore/tesla_activity/tesla_views/optimus.dart';
import 'package:emv/emv/screens/explore/tesla_activity/tesla_views/tesla_energy.dart';
import 'package:emv/emv/screens/explore/tesla_activity/tesla_views/tesla_motors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../base_widgets/news_filter_dialog.dart';
import '../../../commons/helper_functions.dart';
import '../../../commons/icons_logo_strings.dart';
import '../../../commons/stylesheet.dart';
import '../../../handlers/api_handler.dart';
import '../../../handlers/data_handler.dart';
import '../../extras/login_dialog.dart';
import '../../news_section/chat_view.dart';
import '../../news_section/forum_view.dart';
import '../../news_section/multimedia_view.dart';
import '../../news_section/news_view.dart';

class TeslaActivityScreen extends StatefulWidget {
  const TeslaActivityScreen({Key key}) : super(key: key);

  @override
  State<TeslaActivityScreen> createState() => _TeslaActivityScreenState();
}

class _TeslaActivityScreenState extends State<TeslaActivityScreen> {
  final List<Widget> _newsTabList = [
    const NewsViewScreen(),
    ForumViewScreen(route: teslaForumAPI),
    const MultiMediaViewScreen(),
    const ChatViewScreen()
  ];

  final List<Widget> _screenView = [
    const TeslaMotorsView(),
    const TeslaEnergyView(),
    const TeslaOptimusView()
  ];
  final List<String> _newsSectioinList = [
    "News",
    "Forum",
    "Multimedia",
    "Chat"
  ];
  void initState() {
    super.initState();
  }

  int _activeScreeView = 3;
  int _activeNewsIndex = 0;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final theme = Theme.of(context).textTheme;
    bool smallScreen = getScreenWidth(context) < 380;
    return Expanded(
      child: SizedBox(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: getScreenWidth(context) * 0.7,
                  child: FittedBox(
                    child: Row(
                      children: [
                        MaterialButton(
                            padding: EdgeInsets.zero,
                            color: kredColor,
                            shape: RoundedRectangleBorder(
                                side: _activeScreeView == 0
                                    ? BorderSide(color: kBlackColor, width: 2)
                                    : BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () async => {
                                  setState(() => _loading = true),
                                  db.setNewsModel(getDataModel("Tesla Motors")),
                                  db.setColorTheme(kredColor),
                                  setState(() => {_activeScreeView = 0}),
                                  await db.fatchLatestNews(changeRoute: true),
                                  setState(() => _loading = false)
                                },
                            child: Text("Tesla Motors",
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 12,
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.w600))),
                        putWidth(5),
                        MaterialButton(
                            color: kGreenColor,
                            shape: RoundedRectangleBorder(
                                side: _activeScreeView == 1
                                    ? BorderSide(color: kBlackColor, width: 2)
                                    : BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () async => {
                                  setState(() => _loading = true),
                                  db.setColorTheme(kGreenColor),
                                  db.setNewsModel(getDataModel("Tesla Energy")),
                                  setState(() => _activeScreeView = 1),
                                  await db.fatchLatestNews(changeRoute: true),
                                  setState(() => _loading = false)
                                },
                            child: Text(
                              "Tesla Energy",
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 12,
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.w600),
                            )),
                        putWidth(5),
                        MaterialButton(
                            color: Color(0xff00d8b8),
                            shape: RoundedRectangleBorder(
                                side: _activeScreeView == 2
                                    ? BorderSide(color: kBlackColor, width: 2)
                                    : BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () async => {
                                  setState(() => _loading = true),
                                  db.setColorTheme(Color(0xff00d8b8)),
                                  db.setNewsModel(getDataModel("Optimus")),
                                  setState(() => _activeScreeView = 2),
                                  await db.fatchLatestNews(changeRoute: true),
                                  setState(() => _loading = false)
                                },
                            child: Text(
                              "Tesla Optimus",
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 12,
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // SizedBox(
                //   width: getScreenWidth(context) * 0.17,
                //   child:
                //   FittedBox(
                //     child: Container(
                //       // margin: const EdgeInsets.only(right: 5),
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 12, vertical: 5),
                //       height: 40,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: kDefaultColor,
                //       ),
                //       child: Center(
                //         child: InkWell(

                //           child: Text(
                //             "Test Your\nKnowledge",
                //             textAlign: TextAlign.center,
                //             style: GoogleFonts.robotoCondensed(
                //                 fontSize: 12,
                //                 color: Colors.yellow,
                //                 fontWeight: FontWeight.w600),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),

          _activeScreeView == 3
              ? ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  title: FittedBox(
                    child: Row(
                      children: _newsSectioinList
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: GestureDetector(
                                  onTap: () => {
                                    (_newsSectioinList.indexOf(e) == 3) &&
                                            prefs.getString("authToken") == null
                                        ? showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const ShowLoginDialog())
                                        : {
                                            db.setForumState(''),
                                            setState(() => _activeNewsIndex =
                                                _newsSectioinList.indexOf(e))
                                          },
                                  },
                                  child: Chip(
                                      backgroundColor: _activeNewsIndex ==
                                              _newsSectioinList.indexOf(e)
                                          ? kDefaultColor
                                          : kBlackColor.withOpacity(0.1),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      label: FittedBox(
                                        child: Text(
                                          e,
                                          style: theme.headline4.copyWith(
                                              color: _activeNewsIndex ==
                                                      _newsSectioinList
                                                          .indexOf(e)
                                                  ? kWhiteColor
                                                  : kBlackColor),
                                        ),
                                      )),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  trailing: _activeNewsIndex == 0 ||
                          _activeNewsIndex == 1 ||
                          _activeNewsIndex == 2
                      ? IconButton(
                          splashRadius: 25,
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                  builder: (context, setState) =>
                                      NewsFilterDialog(
                                        filterType:
                                            getfilterRoute(_activeNewsIndex),
                                      ))),
                          icon: SvgPicture.asset(filterIcon, width: 25))
                      : SizedBox(),
                )
              : const SizedBox(),
          // : const SizedBox(),
          _loading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : _activeScreeView == 3
                  ? _newsTabList[_activeNewsIndex]
                  : _screenView[_activeScreeView]
        ],
      )),
    );
  }

  getRouting(int index) {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    if (index == 0) {
      null;
    } else if (index == 1) {
      db.setForumState('tesla_default');
    } else if (index == 2) {
      db.setMediaState('teslaMedia_default');
    } else {
      null;
    }
  }
}

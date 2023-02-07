import 'package:emv/emv/screens/explore/tesla_activity/tesla_views/tesla_energy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../base_widgets/news_filter_dialog.dart';
import '../../../../commons/helper_functions.dart';
import '../../../../commons/icons_logo_strings.dart';
import '../../../../commons/stylesheet.dart';
import '../../../../handlers/data_handler.dart';
import '../../../extras/login_dialog.dart';
import '../../../news_section/chat_view.dart';
import '../../../news_section/forum_view.dart';
import '../../../news_section/multimedia_view.dart';
import '../../../news_section/news_view.dart';

class TeslaMotorsView extends StatefulWidget {
  const TeslaMotorsView({Key key}) : super(key: key);

  @override
  State<TeslaMotorsView> createState() => _TeslaMotorsViewState();
}

class _TeslaMotorsViewState extends State<TeslaMotorsView> {
  final List<String> icons = [model_s, model_e, model_x, model_y];
  final List<String> _modelList = ["Model S", "Model E", "Model X", "Model Y"];
  final List<String> _modelList2 = ["Roadster", "Semi", "Cybertruck"];

  final List<Widget> _newsTabList = [
    const NewsViewScreen(),
    ForumViewScreen(),
    const MultiMediaViewScreen(),
    const ChatViewScreen()
  ];
  final List<String> _newsSectioinList = [
    "News",
    "Forum",
    "Multimedia",
    "Chat"
  ];
  int _activeNewsIndex = 0;
  bool _loading = false;
  String _activeModelIndex = "";
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    // final newsList = db.getLatestNews.where((element) => false);
    final theme = Theme.of(context).textTheme;
    return Expanded(
      child: SizedBox(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Row(
                    children: _modelList
                        .map((e) => TextButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    _activeModelIndex == e
                                        ? const BorderSide(
                                            color: kredColor, width: 1.5)
                                        : BorderSide.none),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 7))),
                            onPressed: () async => {
                                  setState(() => _loading = true),
                                  db.setNewsModel(getDataModel(e)),
                                  setState(() => _activeModelIndex = e),
                                  await db.fatchLatestNews().then((value) =>
                                      setState(() => _loading = false))
                                },
                            child: !e.contains("Model")
                                ? Text(
                                    e,
                                    style: theme.headlineMedium,
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("${e.split(" ").first} ",
                                          style: theme.headlineMedium),
                                      Image.asset(
                                        icons[_modelList.indexOf(e)],
                                        height: 10,
                                      )
                                    ],
                                  )))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Row(
                    children: _modelList2
                        .map((e) => TextButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    _activeModelIndex == e
                                        ? const BorderSide(
                                            color: kredColor, width: 1.5)
                                        : BorderSide.none),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 7))),
                            onPressed: () async => {
                                  setState(() => _loading = true),
                                  //toast(getChatModel(getDataModel(e),e)),
                                  db.setNewsModel(getDataModel(e)),
                                  setState(() => _activeModelIndex = e),
                                  await db.fatchLatestNews(),
                                  await db.fetchForums(),
                                  await db.fetchMultimedia(),
                                  setState(() => _loading = false)
                                },
                            child: Text(
                              e,
                              style: theme.headlineMedium,
                            )))
                        .toList(),
                  ),
                ),
              ],
            ),
            ListTile(
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
                                            _newsSectioinList.indexOf(e)),
                                        getRouting(_newsSectioinList.indexOf(e))
                                      }
                              },
                              child: Chip(
                                  backgroundColor: _activeNewsIndex ==
                                          _newsSectioinList.indexOf(e)
                                      ? db.getColorTheme
                                      : kBlackColor.withOpacity(0.1),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  label: Text(
                                    e,
                                    style: theme.headlineMedium.copyWith(
                                        color: _activeNewsIndex ==
                                                _newsSectioinList.indexOf(e)
                                            ? kWhiteColor
                                            : kBlackColor),
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
                              builder: (context, setState) => NewsFilterDialog(
                                    filterType:
                                        getfilterRoute(_activeNewsIndex),
                                  ))),
                      icon: SvgPicture.asset(filterIcon, width: 25))
                  : SizedBox(),
            ),
            _loading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : _newsTabList[_activeNewsIndex]
          ],
        ),
      ),
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

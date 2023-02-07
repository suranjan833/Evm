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

class TeslaEnergyView extends StatefulWidget {
  const TeslaEnergyView({Key key}) : super(key: key);

  @override
  State<TeslaEnergyView> createState() => _TeslaEnergyViewState();
}

class _TeslaEnergyViewState extends State<TeslaEnergyView> {
  final List<String> _modelList = [
    "Gigafactory",
    "Solar Panels/Roof",
    "Powerwall"
  ];
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
  String _activeModelIndex = "";
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final theme = Theme.of(context).textTheme;
    return Expanded(
      child: SizedBox(
        child: Column(
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
                                        color: kGreenColor, width: 1.5)
                                    : BorderSide.none),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 7))),
                        onPressed: () async => {
                              setState(() => _loading = true),
                              //toast(getDataModel(e)),
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
                                            _newsSectioinList.indexOf(e))
                                      },
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
}

String getfilterRoute(int index) {
  switch (index) {
    case 0:
      return "news";
    case 1:
      return "forum";
    case 2:
      return "multi";
    default:
      return '';
  }
}

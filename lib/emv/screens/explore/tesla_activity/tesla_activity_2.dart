import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../commons/icons_logo_strings.dart';
import '../../../commons/stylesheet.dart';
import '../../../handlers/data_handler.dart';
import '../../extras/login_dialog.dart';
import '../../news_section/chat_view.dart';
import '../../news_section/forum_view.dart';
import '../../news_section/multimedia_view.dart';
import '../../news_section/news_view.dart';

class TeslaActivity2Screen extends StatefulWidget {
  const TeslaActivity2Screen({Key key}) : super(key: key);

  @override
  State<TeslaActivity2Screen> createState() => _TeslaActivity2ScreenState();
}

class _TeslaActivity2ScreenState extends State<TeslaActivity2Screen> {
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
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final theme = Theme.of(context).textTheme;
    return Expanded(
        child: SizedBox(
            child: Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          title: FittedBox(
            child: Row(
              children: _newsSectioinList
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: GestureDetector(
                          onTap: () => {
                            _newsSectioinList.indexOf(e) == 3 &&
                                    prefs.getString("authToken") == null
                                ? showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const ShowLoginDialog())
                                : {
                                    db.setForumState(''),
                                    setState(() => _activeNewsIndex =
                                        _newsSectioinList.indexOf(e))
                                  }
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
                                  style: theme.displaySmall.copyWith(
                                      color: _activeNewsIndex ==
                                              _newsSectioinList.indexOf(e)
                                          ? kWhiteColor
                                          : kBlackColor),
                                ),
                              )),
                        ),
                      ))
                  .toList(),
            ),
          ),
          trailing: IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: SvgPicture.asset(searchIcon, width: 25)),
        ),
        _newsTabList[_activeNewsIndex]
      ],
    )));
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

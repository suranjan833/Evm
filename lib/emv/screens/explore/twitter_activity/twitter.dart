import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../commons/icons_logo_strings.dart';
import '../../../commons/stylesheet.dart';
import '../../news_section/chat_view.dart';
import '../../news_section/forum_view.dart';
import '../../news_section/multimedia_view.dart';
import '../../news_section/news_view.dart';

class TwitterActivityScreen extends StatefulWidget {
  const TwitterActivityScreen({Key key}) : super(key: key);

  @override
  State<TwitterActivityScreen> createState() => _TwitterActivityScreenState();
}

class _TwitterActivityScreenState extends State<TwitterActivityScreen> {
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
                          onTap: () => setState(() =>
                              _activeNewsIndex = _newsSectioinList.indexOf(e)),
                          child: Chip(
                              backgroundColor: _activeNewsIndex ==
                                      _newsSectioinList.indexOf(e)
                                  ? kDefaultColor
                                  : kBlackColor.withOpacity(0.1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              label: Text(
                                e,
                                style: theme.headline3.copyWith(
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
          trailing: IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: SvgPicture.asset(searchIcon, width: 25)),
        ),
        _newsTabList[_activeNewsIndex]
      ],
    )));
  }
}

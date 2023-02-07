import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../base_widgets/news_filter_dialog.dart';
import '../../../../commons/icons_logo_strings.dart';
import '../../../../commons/stylesheet.dart';
import '../../../../handlers/data_handler.dart';
import '../../../extras/login_dialog.dart';
import '../../../news_section/chat_view.dart';
import '../../../news_section/forum_view.dart';
import '../../../news_section/multimedia_view.dart';
import '../../../news_section/news_view.dart';

class TeslaOptimusView extends StatefulWidget {
  const TeslaOptimusView({Key key}) : super(key: key);

  @override
  State<TeslaOptimusView> createState() => _TeslaOptimusViewState();
}

class _TeslaOptimusViewState extends State<TeslaOptimusView> {
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
  final bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final theme = Theme.of(context).textTheme;
    return Expanded(
      child: SizedBox(
        child: Column(
          children: [
            // Row(
            //   children: _modelList
            //       .map((e) => Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               TextButton(
            //                   style: ButtonStyle(
            //                       padding: MaterialStateProperty.all(
            //                           const EdgeInsets.symmetric(
            //                               vertical: 0, horizontal: 7))),
            //                   onPressed: () async => {
            //                         setState(() => _loading = true),
            //                         db.setNewsModel(getDataModel(e)),
            //                         setState(() => _activeModelIndex = e),
            //                         await db.fatchLatestNews(),
            //                         await db.fetchForums(),
            //                         await db.fetchMultimedia(),
            //                         setState(() => _loading = false)
            //                       },
            //                   child: Text(
            //                     e,
            //                     style: theme.headline4,
            //                   )),
            //               _activeModelIndex == e
            //                   ? Container(
            //                       height: 1.2,
            //                       width: 40,
            //                       color: kGreenColor,
            //                     )
            //                   : const SizedBox(
            //                       height: 0,
            //                     )
            //             ],
            //           ))
            //       .toList(),
            // ),
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
              trailing: _activeNewsIndex == 0
                  ? IconButton(
                      splashRadius: 25,
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                              builder: (context, setState) => NewsFilterDialog(
                                    filterType: "news",
                                  ))),
                      icon: SvgPicture.asset(filterIcon, width: 25))
                  : _activeNewsIndex == 1
                      ? IconButton(
                          splashRadius: 25,
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                  builder: (context, setState) =>
                                      NewsFilterDialog(
                                        filterType: "forum",
                                      ))),
                          icon: SvgPicture.asset(filterIcon,
                              width:
                                  25) //SvgPicture.asset(filterIcon, width: 25)
                          )
                      : _activeNewsIndex == 2
                          ? IconButton(
                              splashRadius: 25,
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                      builder: (context, setState) =>
                                          NewsFilterDialog(
                                            filterType: "multi",
                                          ))),
                              icon: SvgPicture.asset(filterIcon,
                                  width:
                                      25) //SvgPicture.asset(filterIcon, width: 25)
                              )
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

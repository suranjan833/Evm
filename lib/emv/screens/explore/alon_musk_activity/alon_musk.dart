import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../base_widgets/news_filter_dialog.dart';
import '../../../commons/helper_functions.dart';
import '../../../commons/icons_logo_strings.dart';
import '../../../commons/stylesheet.dart';
import '../../../handlers/data_handler.dart';
import '../../extras/login_dialog.dart';
import '../../news_section/chat_view.dart';
import '../../news_section/forum_view.dart';
import '../../news_section/multimedia_view.dart';
import '../../news_section/news_view_elonmusk.dart';

class AlonMuskActivityScreen extends StatefulWidget {
  const AlonMuskActivityScreen({Key key}) : super(key: key);

  @override
  State<AlonMuskActivityScreen> createState() => _AlonMuskActivityScreenState();
}

class _AlonMuskActivityScreenState extends State<AlonMuskActivityScreen> {
  final List<String> _modelList = [
    "Artificial Intelligence",
    "The Boring Company",
    "Hyperloop",
  ];
  String _activeModelIndex = '';
  final List<Widget> _newsTabList = [
    const NewsViewScreenElonMusk(),
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
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final theme = Theme.of(context).textTheme;
    bool smallScreen = getScreenWidth(context) < 380;
    return Expanded(
        child: SizedBox(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Wrap(
              children: List.generate(
                  _modelList.length + 1,
                  (i) => i == _modelList.length
                      ? Text("")
                      // SizedBox(
                      //     width: getScreenWidth(context) * 0.17,
                      //     child: FittedBox(
                      //       child: Container(
                      //         // margin: const EdgeInsets.only(right: 5),
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 12, vertical: 5),
                      //         height: 40,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: kDefaultColor,
                      //         ),
                      //         child: Center(
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
                      //   )
                      : Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: TextButton(
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                      _activeModelIndex == _modelList[i]
                                          ? const BorderSide(
                                              color: kBlackColor, width: 1.5)
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
                                    db.setNewsModel(
                                        getDataModel(_modelList[i])),
                                    setState(() =>
                                        _activeModelIndex = _modelList[i]),
                                    await db.fatchLatestNews(),
                                    await db.fetchForums(),
                                    await db.fetchMultimedia(),
                                    setState(() => _loading = false)
                                  },
                              child: !_modelList[i].contains("Model")
                                  ? Text(
                                      _modelList[i],
                                      style: theme.headlineMedium,
                                    )
                                  : Text.rich(TextSpan(
                                      text:
                                          "${_modelList[i].split(" ").first} ",
                                      style: theme.headlineMedium,
                                      children: [
                                          TextSpan(
                                              text:
                                                  _modelList[i].split(" ").last,
                                              style: theme.headlineMedium
                                                  .copyWith(color: kredColor))
                                        ]))),
                        ))),
        ),
        // Wrap(
        //   children: _modelList
        //       .map((e) => Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               TextButton(
        //                   style: ButtonStyle(
        //                       padding: MaterialStateProperty.all(
        //                           const EdgeInsets.symmetric(vertical: 0))),
        //                   onPressed: () => setState(
        //                       () => _activeModelIndex = _modelList.indexOf(e)),
        //                   child: !e.contains("Model")
        //                       ? Text(
        //                           e,
        //                           style: theme.headline4,
        //                         )
        //                       : Text.rich(TextSpan(
        //                           text: "${e.split(" ").first} ",
        //                           style: theme.headline4,
        //                           children: [
        //                               TextSpan(
        //                                   text: e.split(" ").last,
        //                                   style: theme.headline4!
        //                                       .copyWith(color: kredColor))
        //                             ]))),
        //               _activeModelIndex == _modelList.indexOf(e)
        //                   ? Container(
        //                       height: 1.2,
        //                       width: 75,
        //                       color: kredColor,
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
                                        _newsSectioinList.indexOf(e)),
                                    getRouting(_newsSectioinList.indexOf(e))
                                  }
                          },
                          child: Chip(
                              backgroundColor: _activeNewsIndex ==
                                      _newsSectioinList.indexOf(e)
                                  ? kDefaultColor
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
                              builder: (context, setState) => NewsFilterDialog(
                                    filterType: "forum",
                                  ))),
                      icon: SvgPicture.asset(filterIcon,
                          width: 25) //SvgPicture.asset(filterIcon, width: 25)
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
            ? const Expanded(child: Center(child: CircularProgressIndicator()))
            : _newsTabList[_activeNewsIndex]
      ],
    )));
  }

  getRouting(int index) {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    if (index == 0) {
      null;
    } else if (index == 1) {
      db.setForumState('alon_musk_forum');
    } else if (index == 2) {
      db.setMediaState('alonMusk_media');
    } else {
      null;
    }
  }
}

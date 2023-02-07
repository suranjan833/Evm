import 'dart:developer' as db;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../commons/empty_data.dart';
import '../../commons/helper_functions.dart';
import '../../commons/icons_logo_strings.dart';
import '../../commons/stylesheet.dart';
import '../../handlers/data_handler.dart';
import '../../handlers/models.dart';
import '../detail_pages/news_detail_view.dart';
import '../dialogs/rating_dialog.dart';
import '../extras/login_dialog.dart';
import '../pop_ups/flag_popup.dart';
import 'base_widgets/footer_section.dart';
// import 'package:html/parser.dart' as htmlparser;
// import 'package:html/dom.dart' as dom;

class NewsViewScreenSpaceX extends StatefulWidget {
  const NewsViewScreenSpaceX({Key key}) : super(key: key);

  @override
  State<NewsViewScreenSpaceX> createState() => _NewsViewScreenSpaceXState();
}

class _NewsViewScreenSpaceXState extends State<NewsViewScreenSpaceX> {
  List<int> likedIndex = [];
  bool _loading = false;
  bool refreshing = false;
  String currentAction = '';

  /// activity Values
  bool likeProcess = false;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    fatchData();
    _controller.addListener(() {
      refreshPosts();
    });
    super.initState();
  }

  refreshPosts() async {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() => refreshing = true);
      await db
          .fatchLatestNewsSpaceXLoadMore()
          .then((value) => setState(() => refreshing = false));
      // await Future.delayed(const Duration(milliseconds: 300));
      // SchedulerBinding.instance?.addPostFrameCallback((_) {
      //   _controller.animateTo(
      //       _controller.position.minScrollExtent,
      //       duration: const Duration(milliseconds: 400),
      //       curve: Curves.fastOutSlowIn);
      // });
    }
  }

  fatchData() async {
    setState(() => _loading = true);
    final db = Provider.of<AppDataHandler>(context, listen: false);
    await db
        .fatchLatestNews()
        .then((value) => setState(() => _loading = false));
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final theme = Theme.of(context).textTheme;
    final ads = db.getAdvertisements;
    final newsList = db.getLatestNews;

    newsList.removeWhere((element) =>
        db.getFlagsList.any((flag) => flag.toString() == element.newsId));
    // ads.shuffle();
    if (db.type == "Filter") {
      db.type = "";
      _scrollDown();
    }
    return Expanded(
      child: SizedBox(
          child: Stack(
        children: [
          newsList.isEmpty
              ? _loading
                  ? Center(child: CircularProgressIndicator())
                  : const EmptyDataView()
              : ListView.builder(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  itemCount: newsList.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    final news = newsList[i];
                    return i % 7 == 0 && ads.isNotEmpty && i != 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CarouselSlider(
                                items: ads
                                    .map((e) => AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: CachedNetworkImage(
                                          imageUrl: e,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )))
                                    .toList(),
                                options: CarouselOptions(
                                    autoPlayInterval:
                                        const Duration(milliseconds: 2500),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 400),
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 1)),
                          )
                        : Container(
                            color: kWhiteColor,
                            child: i != newsList.length - 1
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () => pushTo(
                                                context,
                                                NewsDetailsViewScreen(
                                                    news: news)),
                                            child: AspectRatio(
                                              aspectRatio: 16 / 8,
                                              child: Container(
                                                color: kWhiteColor,
                                                child: CachedNetworkImage(
                                                  imageUrl: news.thumbImage,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                          _ratingBarTile(context, theme, news),
                                          InkWell(
                                            onTap: () => pushTo(
                                                context,
                                                NewsDetailsViewScreen(
                                                    news: news)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                news.title,
                                                textAlign: TextAlign.left,
                                                style: theme.displaySmall,
                                              ),
                                            ),
                                          ),
                                          const Divider(thickness: 1.2),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 10),
                                        width: getScreenWidth(context),
                                        child: getScreenWidth(context) < 320
                                            ? Wrap(
                                                spacing: 10,
                                                children:
                                                    getDetailSection(news),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children:
                                                    getDetailSection(news)),
                                      ),
                                      Container(
                                        width: getScreenWidth(context),
                                        height: 5,
                                        color: kBlackColor.withOpacity(0.5),
                                      )
                                    ],
                                  )
                                : MaterialButton(
                                    onPressed: () {
                                      refreshPosts();
                                    },
                                    child: Text("Load More"),
                                  ),
                          );
                  }),
          refreshing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: getScreenWidth(context),
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white12, Colors.white],
                            begin: AlignmentDirectional.topCenter,
                            end: AlignmentDirectional.bottomCenter),
                      ),
                      child: Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
                )
              : Text(""),
        ],
      )),
    );
  }

  int like = 0;
  int id = 0;
  var isLike = true;
  List<Widget> getDetailSection(NewsModel news) {
    return [
      (likeProcess == true && currentAction == news.newsId
          ? isLike
              ? NewsFooterSection(
                  iconColor: kredColor,
                  icon: likeIcon,
                  label:
                      "${news.likes + (id == int.parse(news.newsId) ? like : 0)} Likes")
              : CircularProgressIndicator()
          //showMiniLoader(20)
          : InkWell(
              onTap: () async {
                if (prefs.getString("authToken") == null) {
                  showDialog(
                      context: context,
                      builder: (context) => const ShowLoginDialog());
                } else {
                  isLike = false;
                  like = 1;
                  id = int.parse(news.newsId);
                  isLike = await onPostLike(news.newsId);
                }
              },
              /*=> prefs.getString("authToken") == null
                  ? showDialog(
                      context: context,
                      builder: (context) => const ShowLoginDialog())
                  : onPostLike(news.newsId)*/
              child: NewsFooterSection(
                  iconColor: kredColor,
                  icon: likeIcon,
                  label:
                      "${news.likes + (id == int.parse(news.newsId) ? like : 0)} Likes"),
            )),
      NewsFooterSection(
          iconColor: kGreenColor, icon: viewIcon, label: "${news.views} Views"),
      InkWell(
          onTap: () => prefs.getString("authToken") == null
              ? showDialog(
                  context: context,
                  builder: (context) => const ShowLoginDialog())
              : pushTo(
                  context, NewsDetailsViewScreen(news: news, isComment: true)),
          child: NewsFooterSection(
              iconColor: const Color.fromARGB(255, 25, 96, 154),
              icon: commentIcon,
              label: "${news.comments} Comments")),
      GestureDetector(
          onTap: () => prefs.getString("authToken") == null
              ? showDialog(
                  context: context,
                  builder: (context) => const ShowLoginDialog())
              : showDialog(
                  context: context,
                  builder: (context) => StatefulBuilder(
                      builder: (context, setState) => Builder(
                          builder: (context) => FlagPopUpView(
                                title: news.title,
                                blogId: news.newsId,
                                type: 1,
                              )))),
          child: NewsFooterSection(
              iconColor: kOrangeColor,
              icon: flagIcon,
              label: "FLAG ${news.flag} OF 10")),
      InkWell(
          onTap: () => share(link: news.newsLink, title: news.title),
          child: NewsFooterSection(
              iconColor: const Color.fromARGB(255, 2, 51, 211),
              icon: shareIcon,
              label: "Share"))
    ];
  }

  onPostLike(String id) async {
    print(id);
    setState(() => currentAction = id);
    final db = Provider.of<AppDataHandler>(context, listen: false);
    setState(() => likeProcess = true);
    await db
        .submitNewsLike(id, 1)
        .then((value) => setState(() => likeProcess = false));
    return true;
  }

  //** Rating bar widget shown below the news thumbnail */
  Container _ratingBarTile(
      BuildContext context, TextTheme theme, NewsModel news) {
    return Container(
      color: kBlackColor.withOpacity(0.1),
      width: getScreenWidth(context),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => prefs.getString("authToken") == null
                ? showDialog(
                    context: context,
                    builder: (context) => const ShowLoginDialog())
                : showDialog(
                    context: context,
                    builder: (context) => RatingDialogView(
                          blogId: news.newsId,
                          mediaType: "news",
                        )),
            child: RatingBar(
              initialRating: news.rating,
              itemSize: 15,
              ignoreGestures: true,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: const Icon(
                  Icons.star,
                  color: ratingBarColor,
                ),
                half: const Icon(Icons.star_half, color: ratingBarColor),
                empty: const Icon(Icons.star_outline),
              ),
              itemPadding: EdgeInsets.zero,
              onRatingUpdate: (rating) {
                null;
              },
            ),
          ),
          putWidth(10),
          Text(DateFormat("MMM dd, yyyy").format(
              DateFormat("y-M-d").parse(news.pubDate.substring(0, 10)))),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                  onPressed: () => pushTo(
                      context, NewsDetailsViewScreen(news: news, pageIndex: 0)),
                  child: Text(
                      news.source.length > 10
                          ? news.source.substring(0, 10) + ".."
                          : news.source,
                      style: textTheme(context).headlineSmall)),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 20,
                color: kBlackColor.withOpacity(0.3),
              )
            ],
          )
        ],
      ),
    );
  }

  onLikePressed(int index) {
    db.log("Button Pressed");
    if (likedIndex.any((element) => element == index)) {
      setState(() => likedIndex.removeWhere((element) => element == index));
    } else {
      setState(() => likedIndex.add(index));
    }
  }

  bool isLiked(int index) => likedIndex.any((element) => element == index);
}

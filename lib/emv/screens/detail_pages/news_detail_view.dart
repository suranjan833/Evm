import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../commons/custom_loading_indicator.dart';
import '../../commons/helper_functions.dart';
import '../../commons/icons_logo_strings.dart';
import '../../commons/stylesheet.dart';
import '../../commons/toast.dart';
import '../../handlers/data_handler.dart';
import '../../handlers/models.dart';
import '../dialogs/rating_dialog.dart';
import '../extras/login_dialog.dart';
import '../news_section/base_widgets/footer_section.dart';
import '../pop_ups/flag_popup.dart';

class NewsDetailsViewScreen extends StatefulWidget {
  int pageIndex;
  NewsModel news;
  bool isComment;
  NewsDetailsViewScreen(
      {Key key,
      @required this.news,
      this.pageIndex = 1,
      this.isComment = false})
      : super(key: key);

  @override
  State<NewsDetailsViewScreen> createState() => _NewsDetailsViewScreenState();
}

class _NewsDetailsViewScreenState extends State<NewsDetailsViewScreen> {
  final FocusNode _commentFocus = FocusNode();
  final FocusNode _commentSubFocus = FocusNode();
  final TextEditingController _commentCtrl = TextEditingController();
  final TextEditingController _commentSubCtrl = TextEditingController();
  final List<String> _tabButton = ["Web", "Smart"];
  int _currentTabIndex = 1;
  int ratingcount = 0;
  bool _loading = false;
  bool posting = false;
  bool postings = false;
  bool likeProcess = false;
  String routing_to = "";
  String currentAction = '';
  String image = '';
  bool isSubComment = false;
  String blog_id = '';
  String commentByy = '';

  int likecount = 0;
  int check_click = 0;
  dynamic rating = 0.0;
  @override
  void initState() {
    super.initState();
    getComments();
    reloadScreen();
    setState(() => _currentTabIndex = widget.pageIndex);
    image = prefs.getString('profile_image');
    // requestFocus();
  }

  requestFocus() => widget.isComment ? _commentFocus.requestFocus() : null;
  getComments() async {
    setState(() => _loading = true);
    final db = Provider.of<AppDataHandler>(context, listen: false);
    db.emptyContent();
    db.fatchComments(widget.news.newsId, 1);
    await db
        .fetchNewsDetails(widget.news.newsId)
        .then((value) => setState(() => _loading = false));
    requestFocus();
  }

  reloadScreen() async {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    await db.getNewsDetailsById(widget.news.newsId).then((value) => {
          print(db.newsModelDetailByid['rating'].toString()),
          rating = double.parse(db.newsModelDetailByid['rating']),
          setState(() {}),
        });
  }

  getRoute() {
    switch (routing_to) {
      case "Home":
        return getPop(context);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final db = Provider.of<AppDataHandler>(context);
    final content = db.getNewsDetail;

    return GestureDetector(
      onTap: () => unfocus(context),
      child: Scaffold(
        appBar: _Appbar(theme, context),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(10, 13, 10, 10),
          height: 60,
          width: getScreenWidth(context),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: getDetailSection(widget.news, likecount)),
        ),
        body: Stack(
          children: [
            SafeArea(
                child: _currentTabIndex == 0
                    ? WebView(
                        onProgress: (p) {
                          p < 50
                              ? setState(() => _loading = true)
                              : setState(() => _loading = false);
                        },
                        initialUrl: widget.news.newsLink,
                        javascriptMode: JavascriptMode.unrestricted,
                      )
                    : SingleChildScrollView(
                        child: GestureDetector(
                        onPanUpdate: (details) => {
                          if (details.delta.dx > 4 &&
                              (details.delta.dy > -4 && details.delta.dy < 4))
                            {setState(() => routing_to = "Home")}
                          else
                            {setState(() => routing_to = "")}
                        },
                        onPanEnd: (details) => {getRoute()},
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                color: kWhiteColor,
                                child: CachedNetworkImage(
                                  imageUrl: widget.news.thumbImage,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.news.source,
                                    style: theme.displaySmall,
                                  ),
                                  putHeight(15),
                                  Text(
                                    widget.news.title,
                                    style: theme.displaySmall,
                                  ),
                                  putHeight(15),
                                  Html(
                                    data: content,
                                    style: {
                                      "body": Style(
                                        color: kBlackColor,
                                        textAlign: TextAlign.justify,
                                        fontSize: const FontSize(16.0),
                                      ),
                                    },
                                  ),
                                  putHeight(20),
                                  Consumer<AppDataHandler>(
                                      builder: (context, data, _) {
                                    final comments = data.getComments;
                                    comments.sort((a, b) =>
                                        DateFormat("y-m-d h:m:s")
                                            .parse(b.dateTime)
                                            .compareTo(DateFormat("y-m-d h:m:s")
                                                .parse(a.dateTime)));
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Comments",
                                              style: theme.displayMedium,
                                            ),
                                            comments.isEmpty ||
                                                    comments.length <= 3
                                                ? const SizedBox()
                                                : TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      "View All",
                                                      style: theme
                                                          .headlineMedium
                                                          .copyWith(
                                                              color:
                                                                  kDefaultColor),
                                                    ))
                                          ],
                                        ),
                                        putHeight(10),
                                        ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: comments.length > 3
                                              ? 3
                                              : comments.length,
                                          itemBuilder: (ctx, i) => ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: image != null
                                                  ? NetworkImage(image)
                                                  : AssetImage(
                                                      imagePlaceHolder),
                                            ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  prefs.getString('name'),
                                                  style: theme.displaySmall,
                                                ),
                                                Text(
                                                  comments[i].dateTime,
                                                  style: theme.headlineMedium
                                                      .copyWith(
                                                          fontSize: 12,
                                                          color: kBlackColor
                                                              .withOpacity(
                                                                  0.4)),
                                                ),
                                                putHeight(10)
                                              ],
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      comments[i].comment,
                                                      style: theme
                                                          .headlineMedium
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        itemCount: comments[i]
                                                            .reply
                                                            .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundImage: comments[i]
                                                                              .reply[index]
                                                                          [
                                                                          'user'] !=
                                                                      null
                                                                  ? NetworkImage(comments[i]
                                                                              .reply[index]
                                                                          [
                                                                          'user']
                                                                      [
                                                                      'avatar'])
                                                                  : AssetImage(
                                                                      imagePlaceHolder),
                                                            ),
                                                            title: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  comments[i].reply[index]
                                                                              [
                                                                              'user'] !=
                                                                          null
                                                                      ? comments[i].reply[index]
                                                                              [
                                                                              'user']
                                                                          [
                                                                          'name']
                                                                      : "",
                                                                  style: theme
                                                                      .displaySmall,
                                                                ),
                                                                Text(
                                                                  comments[i].reply[
                                                                          index]
                                                                      [
                                                                      'created_at'],
                                                                  style: theme
                                                                      .headlineMedium
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              kBlackColor.withOpacity(0.4)),
                                                                ),
                                                                putHeight(10)
                                                              ],
                                                            ),
                                                            subtitle: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      comments[i]
                                                                              .reply[index]
                                                                          [
                                                                          'comments'],
                                                                      style: theme
                                                                          .headlineMedium
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ); /*Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                              comments[i].reply[index]['comments'],
                                                              style:
                                                              theme.headline4.copyWith(
                                                                fontWeight: FontWeight.w300,
                                                              ),
                                                        ),
                                                            ],
                                                          ),),
                                                        SizedBox(height: 10,),
                                                        comments[i].reply[index]['comments'] == null ?InkWell(
                                                            onTap: () => setState((){
                                                              isSubComment = !isSubComment;
                                                            }),
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.reply_all,color: Colors.black,),
                                                                SizedBox(width: 5,),
                                                                Text("REPLY",style: TextStyle(color: Colors.black),)
                                                              ],
                                                            )
                                                        ): SizedBox(),

                                                    ],
                                                    );*/
                                                        }),
                                                    putHeight(8),
                                                    comments[i].reply.isEmpty
                                                        ? InkWell(
                                                            onTap: () =>
                                                                setState(() {
                                                                  isSubComment =
                                                                      !isSubComment;
                                                                  blog_id = comments[
                                                                          i]
                                                                      .commentId
                                                                      .toString();
                                                                  commentByy = comments[
                                                                          i]
                                                                      .commentBy
                                                                      .toString();
                                                                }),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .reply_all,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "REPLY",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                )
                                                              ],
                                                            ))
                                                        : SizedBox(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  putHeight(20),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: kBlackColor
                                                    .withOpacity(0.2))),
                                        child: TextField(
                                          readOnly:
                                              prefs.getString("authToken") ==
                                                  null,
                                          onTap: () => prefs
                                                      .getString("authToken") ==
                                                  null
                                              ? showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      const ShowLoginDialog())
                                              : null,
                                          controller: isSubComment
                                              ? _commentSubCtrl
                                              : _commentCtrl,
                                          focusNode: isSubComment
                                              ? _commentSubFocus
                                              : _commentFocus,
                                          decoration: InputDecoration(
                                              hintText: isSubComment
                                                  ? "Leave a reply"
                                                  : "Comment",
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                              suffixIcon: posting
                                                  ? const IconButton(
                                                      onPressed: null,
                                                      icon: Center(
                                                          child:
                                                              CircularProgressIndicator()))
                                                  : IconButton(
                                                      onPressed: () async {
                                                        if (isSubComment) {
                                                          if (_commentSubCtrl
                                                              .text.isEmpty) {
                                                            null;
                                                          } else {
                                                            setState(() =>
                                                                postings =
                                                                    true);
                                                            var sent = await db
                                                                .postSubNewsComments(
                                                                    widget.news
                                                                        .newsId,
                                                                    blog_id,
                                                                    commentByy,
                                                                    _commentSubCtrl
                                                                        .text,
                                                                    1);

                                                            sent
                                                                ? setState(() =>
                                                                    _commentSubCtrl
                                                                        .clear())
                                                                : toast(
                                                                    "could not sent");
                                                            //  pop(context);
                                                            setState(() =>
                                                                postings =
                                                                    false);
                                                            setState(() =>
                                                                isSubComment =
                                                                    false);
                                                          }
                                                        } else {
                                                          if (_commentCtrl
                                                              .text.isEmpty) {
                                                            null;
                                                          } else {
                                                            setState(() =>
                                                                posting = true);
                                                            var sent = await db
                                                                .postNewsComments(
                                                                    widget.news
                                                                        .newsId,
                                                                    _commentCtrl
                                                                        .text,
                                                                    1);

                                                            sent
                                                                ? setState(() =>
                                                                    _commentCtrl
                                                                        .clear())
                                                                : toast(
                                                                    "could not sent");
                                                            //  pop(context);
                                                            setState(() =>
                                                                posting =
                                                                    false);
                                                          }
                                                        }
                                                      },
                                                      icon: const Icon(
                                                        Icons.send,
                                                        color: kDefaultColor,
                                                      )),
                                              prefixIcon: IconButton(
                                                  onPressed: null,
                                                  icon: SvgPicture.asset(
                                                    userIcon,
                                                    width: 20,
                                                  ))),
                                        ),
                                      )),
                                    ],
                                  ),
                                  putHeight(20)
                                ],
                              ),
                            )
                          ],
                        ),
                      ))),
            _loading ? const CustomLoadingIndicator() : const SizedBox()
          ],
        ),
      ),
    );
  }

  onPostLike(String id) async {
    print('onpost like');
    final db = Provider.of<AppDataHandler>(context, listen: false);
    setState(() => likeProcess = true);
    await db.submitNewsLike(id, 1).then((value) => setState(() => {
          likeProcess = false,
          if (likecount == 0) {likecount = 1} else {likecount = 0}
        }));
  }

  AppBar _Appbar(TextTheme theme, BuildContext context) {
    return AppBar(
      elevation: 0,
      foregroundColor: kBlackColor,
      backgroundColor: kWhiteColor,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _tabButton
            .map((e) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: () => setState(
                            () => _currentTabIndex = _tabButton.indexOf(e)),
                        child: Text(
                          e,
                          style: theme.displaySmall,
                        )),
                    _currentTabIndex == _tabButton.indexOf(e)
                        ? Container(
                            width: 100,
                            height: 1.5,
                            color: kDefaultColor,
                          )
                        : const SizedBox()
                  ],
                ))
            .toList(),
      ),
      actions: [
        IconButton(
            onPressed: () async => await share(
                link: widget.news.newsLink, title: widget.news.title),
            icon: SvgPicture.asset(
              shareIcon,
              width: 20,
            ))
      ],
      bottom: PreferredSize(
          preferredSize: Size(getScreenWidth(context), 50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat("MMM dd, yyyy").format(DateFormat("y-M-d")
                      .parse(widget.news.pubDate.substring(0, 10))),
                  style: theme.headlineSmall,
                ),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () => prefs.getString("authToken") == null
                      ? showDialog(
                          context: context,
                          builder: (context) => const ShowLoginDialog())
                      : showDialog(
                          context: context,
                          builder: (context) => RatingDialogView(
                                blogId: widget.news.newsId,
                                mediaType: "news",
                              )).then((value) {
                          // pop(context);
                          reloadScreen();
                          //((){rating=value;});
                        }),
                  child: Container(
                    color: kWhiteColor,
                    padding: const EdgeInsets.all(5),
                    child: RatingBar(
                      initialRating: rating != 0 ? rating : widget.news.rating,
                      itemSize: 20,
                      ignoreGestures: true,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: ratingBarColor),
                        half:
                            const Icon(Icons.star_half, color: ratingBarColor),
                        empty: const Icon(Icons.star_outline),
                      ),
                      itemPadding: EdgeInsets.zero,
                      onRatingUpdate: (rati) {
                        rating = rating + rati / 2;
                        setState(() => {});
                        //toast("msg");
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  List<Widget> getDetailSection(NewsModel news, int likecount) {
    return [
      likeProcess == true && currentAction == news.newsId
          ? Text("Loading")
          : InkWell(
              onTap: () => prefs.getString("authToken") == null
                  ? showDialog(
                      context: context,
                      builder: (context) => const ShowLoginDialog())
                  : onPostLike(news.newsId),
              child: NewsFooterSection(
                  iconColor: kredColor,
                  icon: likeIcon,
                  label: "${news.likes + likecount} Likes"),
            ),
      NewsFooterSection(
          iconColor: kGreenColor, icon: viewIcon, label: "${news.views} Views"),
      InkWell(
          onTap: () => prefs.getString("authToken") == null
              ? showDialog(
                  context: context,
                  builder: (context) => const ShowLoginDialog())
              : _commentFocus
                  .requestFocus(), //pushTo(context, NewsDetailsViewScreen(news: news, isComment: true)),
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
    ];
  }

  dom.Document convertText(String text) {
    dom.Document myDocument = htmlparser.parse(text);
    return myDocument;
  }
}

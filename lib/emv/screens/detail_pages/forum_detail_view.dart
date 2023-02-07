import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

class ForumDetailScreen extends StatefulWidget {
  ForumsModel forum;
  bool isComment;
  ForumDetailScreen({Key key, @required this.forum, this.isComment = false})
      : super(key: key);

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  final FocusNode _commentFocus = FocusNode();
  final TextEditingController _commentCtrl = TextEditingController();
  bool liking = false;
  @override
  void initState() {
    super.initState();
    getComments();
    requestFocus();
    viewCounter();
  }

  viewCounter() async {
    Map<String, String> data = {"forum_id": widget.forum.id};
    var value = await AppDataHandler().viewCounterFunction("forum", data);
    value ? await AppDataHandler().fetchForums() : null;
  }

  getComments() async {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    db.fatchComments(widget.forum.id, 2);
  }

  requestFocus() => widget.isComment ? _commentFocus.requestFocus() : null;

  bool posting = false;
  String routing_to = "";
  bool likeSubmit = false;
  String currentAction = '';

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
    final db = Provider.of<AppDataHandler>(context);
    final theme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => unfocus(context),
      onPanUpdate: (details) {
        if (details.delta.dx > 8) {
          setState(() => routing_to = "Home");
        }
      },
      onPanEnd: (details) {
        getRoute();
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kWhiteColor,
          foregroundColor: kBlackColor,
          actions: [
            IconButton(
                onPressed: () => share(
                    title: widget.forum.question,
                    link: widget.forum.description),
                icon: SvgPicture.asset(
                  shareIcon,
                  width: 20,
                ))
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(10, 13, 10, 10),
          height: 60,
          width: getScreenWidth(context),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: getitems(widget.forum)),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat("MMM dd, yyyy")
                            .format(DateFormat("y-m-d").parse("2022-08-10")),
                        style: theme.headlineSmall,
                      ),
                      putWidth(20),
                      InkWell(
                        onTap: () => prefs.getString("authToken") == null
                            ? showDialog(
                                context: context,
                                builder: (context) => const ShowLoginDialog())
                            : showDialog(
                                context: context,
                                builder: (context) => RatingDialogView(
                                      blogId: widget.forum.id,
                                      mediaType: "forum",
                                    )),
                        child: Container(
                          color: kWhiteColor,
                          padding: const EdgeInsets.all(3),
                          child: RatingBar(
                            initialRating: widget.forum.ratings,
                            itemSize: 15,
                            ignoreGestures: true,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            ratingWidget: RatingWidget(
                              full:
                                  const Icon(Icons.star, color: ratingBarColor),
                              half: const Icon(Icons.star_half,
                                  color: ratingBarColor),
                              empty: const Icon(Icons.star_outline),
                            ),
                            itemPadding: EdgeInsets.zero,
                            onRatingUpdate: (rating) {
                              null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  putHeight(10),
                  Text(
                    "By Admin (${widget.forum.name})",
                    style: theme.headlineSmall,
                  ),
                  putHeight(10),
                  Text(
                    widget.forum.question,
                    style: theme.displaySmall,
                  ),
                  putHeight(15),
                  Text(
                    widget.forum.description,
                    textAlign: TextAlign.justify,
                    style: theme.headlineMedium.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  putHeight(20),
                  Consumer<AppDataHandler>(builder: (context, data, _) {
                    final comments = data.getComments;
                    comments.sort((a, b) => DateFormat("y-M-d h:m:s")
                        .parse(b.dateTime)
                        .compareTo(
                            DateFormat("y-M-d h:m:s").parse(a.dateTime)));
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Comments",
                              style: theme.displayMedium,
                            ),
                            comments.isEmpty || comments.length <= 3
                                ? const SizedBox()
                                : TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "View All",
                                      style: theme.headlineMedium
                                          .copyWith(color: kDefaultColor),
                                    ))
                          ],
                        ),
                        putHeight(10),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: comments.length > 3 ? 3 : comments.length,
                          itemBuilder: (ctx, i) => ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: AssetImage(imagePlaceHolder),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Unknown",
                                  style: theme.displaySmall,
                                ),
                                Text(
                                  comments[i].dateTime,
                                  style: theme.headlineMedium.copyWith(
                                      fontSize: 12,
                                      color: kBlackColor.withOpacity(0.4)),
                                ),
                                putHeight(10)
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comments[i].comment,
                                  style: theme.headlineMedium.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
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
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: kBlackColor.withOpacity(0.2))),
                        child: TextField(
                          focusNode: _commentFocus,
                          controller: _commentCtrl,
                          readOnly: prefs.getString("authToken") == null,
                          onTap: () => prefs.getString("authToken") == null
                              ? showDialog(
                                  context: context,
                                  builder: (context) => const ShowLoginDialog())
                              : null,
                          decoration: InputDecoration(
                              hintText: "Comment",
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              prefixIcon: IconButton(
                                  onPressed: null,
                                  icon: SvgPicture.asset(
                                    userIcon,
                                    width: 20,
                                  )),
                              suffixIcon: posting
                                  ? const IconButton(
                                      onPressed: null,
                                      icon: Center(
                                          child: CircularProgressIndicator()))
                                  : IconButton(
                                      onPressed: () async {
                                        if (_commentCtrl.text.isEmpty) {
                                          null;
                                        } else {
                                          setState(() => posting = true);
                                          var sent = await db.postForumComments(
                                              widget.forum.id,
                                              _commentCtrl.text,
                                              2);

                                          sent
                                              ? setState(
                                                  () => _commentCtrl.clear())
                                              : toast("could not sent");
                                          setState(() => posting = false);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.send,
                                        color: kDefaultColor,
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
        ))),
      ),
    );
  }

  List<Widget> getitems(ForumsModel item) {
    return [
      likeSubmit && currentAction == item.id
          ? showMiniLoader(20)
          : GestureDetector(
              onTap: () => prefs.getString("authToken") == null
                  ? showDialog(
                      context: context,
                      builder: (context) => const ShowLoginDialog())
                  : onLikePressed(item.id),
              child: NewsFooterSection(
                  iconColor: kredColor,
                  icon: likeIcon,
                  label: "${item.likes} Likes"),
            ),
      NewsFooterSection(
          iconColor: kGreenColor, icon: viewIcon, label: "${item.views} Views"),
      GestureDetector(
          onTap: () => prefs.getString("authToken") == null
              ? showDialog(
                  context: context,
                  builder: (context) => const ShowLoginDialog())
              : pushTo(
                  context, ForumDetailScreen(forum: item, isComment: true)),
          child: NewsFooterSection(
              iconColor: const Color.fromARGB(255, 25, 96, 154),
              icon: commentIcon,
              label: "${item.comments} Comments")),
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
                                title: item.question,
                                blogId: item.id,
                                type: 2,
                              )))),
          child: NewsFooterSection(
              iconColor: kOrangeColor,
              icon: flagIcon,
              label: "FLAG ${item.flag_count} OF 10")),
      // InkWell(
      //   onTap: () => share(title: item.question, link: item.description),
      //   child: NewsFooterSection(
      //       iconColor: const Color.fromARGB(255, 2, 51, 211),
      //       icon: shareIcon,
      //       label: "Share"),
      // )
    ];
  }

  onLikePressed(String id) async {
    setState(() => currentAction = id);
    final db = Provider.of<AppDataHandler>(context, listen: false);
    setState(() => likeSubmit = true);
    await db
        .submitNewsLike(id, 2)
        .then((value) => setState(() => likeSubmit = false));
  }

  Map<String, String> getForm(String userId, forumId) {
    Map<String, String> json = {
      "rCommentBlogid": widget.forum.id,
      "commentBy": userId,
      "rCommentComments": _commentCtrl.text,
      "forum_id": forumId
    };
    debugPrint("Forum Comment Data :: $json");
    debugPrint("User Auth Token :: ${prefs.getString("authToken")}");
    return json;
  }
}

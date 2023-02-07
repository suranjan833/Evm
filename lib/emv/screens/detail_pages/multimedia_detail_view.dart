import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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
import '../videoitem.dart';

class MultimediaDetailScreen extends StatefulWidget {
  MultiMediaModel item;
  bool isComment;
  MultimediaDetailScreen({Key key, @required this.item, this.isComment = false})
      : super(key: key);

  @override
  State<MultimediaDetailScreen> createState() => _MultimediaDetailScreenState();
}

class _MultimediaDetailScreenState extends State<MultimediaDetailScreen> {
  final FocusNode _commentFocus = FocusNode();
  final TextEditingController _commentCtrl = TextEditingController();
  bool likeSubmit = false;
  bool posting = false;
  String routing_to = "";
  String currentAction = '';

  @override
  void initState() {
    requestFocus();
    getComments();
    viewCounter();
    super.initState();
  }

  viewCounter() async {
    Map<String, String> data = {"multimedia_id": widget.item.mediaId};
    var value = await AppDataHandler().viewCounterFunction("media", data);
    value ? await AppDataHandler().fetchMultimedia() : null;
  }

  requestFocus() => widget.isComment ? _commentFocus.requestFocus() : null;
  getComments() async {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    db.fatchComments(widget.item.mediaId, 3);
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
                    link: widget.item.description, title: widget.item.title),
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
              children: getItems(widget.item)),
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
                        "May 27, 2022",
                        style: theme.headline5,
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
                                      blogId: widget.item.mediaId,
                                      mediaType: "media",
                                    )),
                        child: Container(
                          color: kWhiteColor,
                          padding: const EdgeInsets.all(3),
                          child: RatingBar(
                            initialRating: widget.item.ratings,
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
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: SizedBox(
                      child: widget.item.image.split(".").length > 3 &&
                              widget.item.image
                                      .split(".")[
                                          widget.item.image.split(".").length -
                                              1]
                                      .toString() ==
                                  "mp4"
                          ? VideoItems(
                              videoPlayerController:
                                  VideoPlayerController.network(
                                      widget.item.image),
                              looping: true,
                              autoplay: false,
                            )
                          : InkWell(
                              onTap: () => pushTo(context,
                                  MultimediaDetailScreen(item: widget.item)),
                              child: AspectRatio(
                                aspectRatio: 16 / 8,
                                child: Container(
                                  color: kWhiteColor,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.item.image,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
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
                            ),
                      // Image.network(widget.item.image, fit: BoxFit.cover),
                    ),
                  ),
                  putHeight(10),
                  Text(
                    '${widget.item.model} : ${widget.item.title}',
                    style: theme.headline3,
                  ),
                  putHeight(15),
                  Text(
                    widget.item.description,
                    textAlign: TextAlign.justify,
                    style: theme.headline3.copyWith(
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
                              style: theme.headline2,
                            ),
                            comments.isEmpty || comments.length <= 3
                                ? const SizedBox()
                                : TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "View All",
                                      style: theme.headline4
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
                                  style: theme.headline3,
                                ),
                                Text(
                                  comments[i].dateTime,
                                  style: theme.headline4.copyWith(
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
                                  style: theme.headline4.copyWith(
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
                                          var sent = await db.postMediaComments(
                                              widget.item.mediaId,
                                              _commentCtrl.text);

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

  List<Widget> getItems(MultiMediaModel item) {
    return [
      likeSubmit && currentAction == item.mediaId
          ? showMiniLoader(20)
          : GestureDetector(
              onTap: () => prefs.getString("authToken") == null
                  ? showDialog(
                      context: context,
                      builder: (context) => const ShowLoginDialog())
                  : onLikePressed(item.mediaId),
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
                  context, MultimediaDetailScreen(item: item, isComment: true)),
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
                              title: item.title,
                              blogId: item.mediaId,
                              type: 3)))),
          child: NewsFooterSection(
              iconColor: kOrangeColor,
              icon: flagIcon,
              label: "FLAG ${item.flag_count} OF 10")),
      // InkWell(
      //     onTap: () => share(title: item.title, link: item.description),
      //     child: NewsFooterSection(
      //         iconColor: const Color.fromARGB(255, 2, 51, 211),
      //         icon: shareIcon,
      //         label: "Share"))
    ];
  }

  onLikePressed(String id) async {
    setState(() => likeSubmit = true);
    final db = Provider.of<AppDataHandler>(context, listen: false);
    await db
        .submitNewsLike(id, 3)
        .then((value) => setState(() => likeSubmit = true));
  }
}

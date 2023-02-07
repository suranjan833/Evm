import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../commons/empty_data.dart';
import '../../commons/helper_functions.dart';
import '../../commons/icons_logo_strings.dart';
import '../../commons/stylesheet.dart';
import '../../handlers/data_handler.dart';
import '../../handlers/models.dart';
import '../detail_pages/multimedia_detail_view.dart';
import '../dialogs/rating_dialog.dart';
import '../dialogs/upload_media.dart';
import '../extras/login_dialog.dart';
import '../pop_ups/flag_popup.dart';
import '../videoitem.dart';
import 'base_widgets/footer_section.dart';

class MultiMediaViewScreen extends StatefulWidget {
  const MultiMediaViewScreen({Key key}) : super(key: key);

  @override
  State<MultiMediaViewScreen> createState() => _MultiMediaViewScreenState();
}

class _MultiMediaViewScreenState extends State<MultiMediaViewScreen> {
  List<int> likedIndex = [];
  VideoPlayerController _controller;
  bool _loading = false;
  bool likeSubmit = false;
  String currentAction = '';

  @override
  void initState() {
    fatchData();
    super.initState();
  }

  fatchData() async {
    setState(() => _loading = true);
    final db = Provider.of<AppDataHandler>(context, listen: false);
    await db
        .fetchMultimedia()
        .then((value) => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final db = Provider.of<AppDataHandler>(context);
    final mediaList = db.getMultiMediaNews;
    print("Multi");
    print(db.getMultiMediaNews);
    print(mediaList);
    mediaList.removeWhere((element) =>
        db.getFlagsList.any((flag) => flag.toString() == element.mediaId));

    return Expanded(
      child: Container(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () => prefs.getString("authToken") == null
                              ? showDialog(
                                  context: context,
                                  builder: (context) => const ShowLoginDialog())
                              : showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const UploadMediaView()),
                          child: Chip(
                              backgroundColor: db.getColorTheme,
                              label: Text(
                                "Upload Media",
                                style: theme.headlineSmall
                                    .copyWith(color: kWhiteColor),
                              )),
                        )
                      ],
                    ),
                    mediaList.isEmpty
                        ? const EmptyDataView()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: mediaList.length,
                            shrinkWrap: true,
                            itemBuilder: (ctx, i) {
                              final item = mediaList[i];
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: kWhiteColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "By Admin(${item.name})",
                                        style: theme.bodySmall,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        item.title,
                                        style: theme.headlineMedium,
                                      ),
                                    ),
                                    item.image.split(".").length > 3 &&
                                            item.image
                                                    .split(".")[mediaList[0]
                                                            .image
                                                            .split(".")
                                                            .length -
                                                        1]
                                                    .toString() ==
                                                "mp4"
                                        ? VideoItems(
                                            videoPlayerController:
                                                VideoPlayerController.network(
                                                    item.image),
                                            looping: true,
                                            autoplay: false,
                                          )
                                        : InkWell(
                                            onTap: () => pushTo(
                                                context,
                                                MultimediaDetailScreen(
                                                    item: item)),
                                            child: AspectRatio(
                                              aspectRatio: 16 / 8,
                                              child: Container(
                                                color: kWhiteColor,
                                                child: CachedNetworkImage(
                                                  imageUrl: item.image,
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
                                    _ratingBarTile(context, theme, item.ratings,
                                        item.mediaId),
                                    putHeight(10),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      width: getScreenWidth(context),
                                      child: getScreenWidth(context) < 320
                                          ? Wrap(
                                              spacing: 10,
                                              children: getItems(item),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: getItems(item),
                                            ),
                                    ),
                                    Container(
                                      width: getScreenWidth(context),
                                      height: 2,
                                      color: kBlackColor.withOpacity(0.5),
                                    )
                                  ],
                                ),
                              );
                            }),
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> getItems(MultiMediaModel item) {
    return [
      likeSubmit && currentAction == item.mediaId
          ? GestureDetector(
              onTap: () => prefs.getString("authToken") == null
                  ? showDialog(
                      context: context,
                      builder: (context) => const ShowLoginDialog())
                  : onLikePressed(item.mediaId),
              child: NewsFooterSection(
                  iconColor: kredColor,
                  icon: likeIcon,
                  label: "${item.likes} Likes"),
            )
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
      InkWell(
          onTap: () => share(title: item.title, link: item.description),
          child: NewsFooterSection(
              iconColor: const Color.fromARGB(255, 2, 51, 211),
              icon: shareIcon,
              label: "Share"))
    ];
  }

  Column _newsFooterBar(TextTheme theme, String icon, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 15,
                color: kBlackColor.withOpacity(0.2),
              ),
              putWidth(5),
              putHeight(5),
              Text(
                label,
                style: theme.headlineMedium
                    .copyWith(color: kBlackColor.withOpacity(0.2)),
              )
            ],
          ),
        )
      ],
    );
  }

  _ratingBarTile(BuildContext context, TextTheme theme, double rating, blogId) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          InkWell(
            onTap: () => prefs.getString("authToken") == null
                ? showDialog(
                    context: context,
                    builder: (context) => const ShowLoginDialog())
                : showDialog(
                    context: context,
                    builder: (context) => RatingDialogView(
                          blogId: blogId,
                          mediaType: "media",
                        )),
            child: Container(
              color: kWhiteColor,
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: RatingBar(
                initialRating: rating,
                itemSize: 15,
                ignoreGestures: true,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: ratingBarColor),
                  half: const Icon(Icons.star_half, color: ratingBarColor),
                  empty: const Icon(Icons.star_outline),
                ),
                itemPadding: EdgeInsets.zero,
                onRatingUpdate: (rating) {
                  null;
                },
              ),
            ),
          ),
          putWidth(10),
          Text(DateFormat("MMM d, y").format(DateTime.now())),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  onLikePressed(String id) async {
    setState(() => currentAction = id);
    final db = Provider.of<AppDataHandler>(context, listen: false);
    setState(() => likeSubmit = true);
    await db
        .submitNewsLike(id, 3)
        .then((value) => setState(() => likeSubmit = false));
  }
}

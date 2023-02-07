import 'package:cached_network_image/cached_network_image.dart';
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
import '../detail_pages/forum_detail_view.dart';
import '../dialogs/create_form_view.dart';
import '../dialogs/rating_dialog.dart';
import '../extras/login_dialog.dart';
import '../pop_ups/flag_popup.dart';
import 'base_widgets/footer_section.dart';

class ForumViewScreen extends StatefulWidget {
  String route;
  ForumViewScreen({Key key, this.route = ''}) : super(key: key);

  @override
  State<ForumViewScreen> createState() => _ForumViewScreenState();
}

class _ForumViewScreenState extends State<ForumViewScreen> {
  List<int> likedIndex = [];

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
    await db.fetchForums().then((value) => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final theme = Theme.of(context).textTheme;
    final forumList = db.getFormList;
    forumList.removeWhere((element) =>
        db.getFlagsList.any((flag) => flag.toString() == element.id));

    return Expanded(
      child: SizedBox(
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
                                      CreatForumView(type: db.getfilterType())),
                          child: Chip(
                              backgroundColor: db.getColorTheme,
                              label: Text("Create Topic",
                                  style: theme.headlineSmall
                                      .copyWith(color: kWhiteColor))),
                        )
                      ],
                    ),
                    forumList.isEmpty
                        ? const EmptyDataView()
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: forumList.length,
                            itemBuilder: ((context, i) {
                              final item = forumList[i];
                              return Container(
                                color: kWhiteColor,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("By Admin()", style: theme.bodySmall),
                                    putHeight(8),
                                    ListTile(
                                      onTap: () {
                                        pushTo(context,
                                            ForumDetailScreen(forum: item));
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      leading: getAvatar(item.avatar),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(item.question,
                                            style: theme.headlineMedium),
                                      ),
                                      subtitle: Text(item.description,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.headlineSmall),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: _ratingBarTile(context, theme,
                                            item.ratings, item.id)),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      width: getScreenWidth(context),
                                      child: Column(
                                        children: [
                                          getScreenWidth(context) < 320
                                              ? Wrap(
                                                  spacing: 10,
                                                  children: getitems(item))
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: getitems(item)),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                        thickness: 1, color: kBlackColor),
                                  ],
                                ),
                              );
                            })),
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> getitems(ForumsModel item) {
    return [
      likeSubmit && currentAction == item.id
          ? GestureDetector(
              onTap: () => prefs.getString("authToken") == null
                  ? showDialog(
                      context: context,
                      builder: (context) => const ShowLoginDialog())
                  : onLikePressed(item.id),
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
      InkWell(
        onTap: () => share(title: item.question, link: item.description),
        child: NewsFooterSection(
            iconColor: const Color.fromARGB(255, 2, 51, 211),
            icon: shareIcon,
            label: "Share"),
      )
    ];
  }

  Widget _ratingBarTile(
      BuildContext context, TextTheme theme, double rating, String blogId) {
    return Row(
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
                        mediaType: "forum",
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
    );
  }

  onLikePressed(String id) async {
    setState(() => currentAction = id);
    final db = Provider.of<AppDataHandler>(context, listen: false);
    setState(() => likeSubmit = true);
    await db
        .submitNewsLike(id, 2)
        .then((value) => setState(() => likeSubmit = false));
  }

  Widget getAvatar(String image) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: kBlackColor.withOpacity(0.1)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: CachedNetworkImage(
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(value: downloadProgress.progress),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

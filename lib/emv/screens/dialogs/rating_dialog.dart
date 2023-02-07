import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../commons/toast.dart';
import '../../handlers/data_handler.dart';

class RatingDialogView extends StatefulWidget {
  String blogId;
  String mediaType;
  RatingDialogView({Key key, @required this.blogId, @required this.mediaType})
      : super(key: key);

  @override
  State<RatingDialogView> createState() => _RatingDialogViewState();
}

class _RatingDialogViewState extends State<RatingDialogView> {
  double ratings = 0;
  bool process = false;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(10),
      title: Text("Rating", style: textTheme(context).displayMedium),
      children: [
        RatingBar(
          initialRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 30,
          ratingWidget: RatingWidget(
            full: const Icon(Icons.star, color: ratingBarColor),
            half: const Icon(Icons.star_half, color: ratingBarColor),
            empty: const Icon(Icons.star_outline),
          ),
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (rating) {
            setState(() => ratings = rating);
            print(rating);
          },
        ),
        putHeight(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            process
                ? const Center(child: CircularProgressIndicator())
                : MaterialButton(
                    color: kDefaultColor,
                    onPressed: () async {
                      setState(() => process = true);
                      bool done = await db.submitRating(
                          widget.blogId, "$ratings", widget.mediaType);
                      if (done) {
                        toast("Rating Submitted");
                        getPop(context);
                      } else {
                        toast("unable to process your request");
                      }
                      setState(() => process = false);
                    },
                    child: Text(
                      "Rate Now",
                      style: textTheme(context)
                          .headlineMedium
                          ?.copyWith(color: kWhiteColor),
                    ))
          ],
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/helper_functions.dart';
import '../commons/stylesheet.dart';
import '../handlers/data_handler.dart';
import 'custom_text_field.dart';

class NewsFilterDialog extends StatefulWidget {
  final String filterType;
  // final int isMulitimedia;
  const NewsFilterDialog({Key key, this.filterType}) : super(key: key);

  @override
  State<NewsFilterDialog> createState() => _NewsFilterDialogState();
}

class _NewsFilterDialogState extends State<NewsFilterDialog> {
  final TextEditingController _keywords = TextEditingController();
  List<String> durationFilter = [
    "Duration",
    "Last 24 hours",
    "Last Week",
    "Last 30 days",
    "All"
  ];
  List<String> typeFilter = ["Most Liked", "Most Discussed", "Most Views"];
  List<String> typeMulitimediafilter = ["All", "Video", "Image"];
  String selectedDuration = "Duration";
  String selectedType = "Most Liked";
  String selectedMultimedia = "All";
  bool showLoader = false;

  String getNewsOrder() {
    switch (selectedType) {
      case "Most Liked":
        return "like_counter";
      case "Most Discussed":
        return "Comment_total";
      case "Most Views":
        return "view_count_one";
      default:
        return '';
    }
  }

  String getNewsStart() {
    switch (selectedDuration) {
      case "Last 24 hours":
        return "yesterday";
      case "Last Week":
        return "-1 week";
      case "Last 30 days":
        return "-1 months";
      case "All":
        return "-12 months";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.all(10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(onPressed: () => getPop(context), icon: Icon(Icons.close))
        ],
      ),
      children: [
        SizedBox(width: getScreenWidth(context)),
        CustomTextField(
          controller: _keywords,
          shrink: true,
          hint: "Keyword",
          showBorder: true,
        ),
        SizedBox(height: 10),
        showLoader
            ? Container(
                width: getScreenWidth(context),
                child: Center(
                  child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator()),
                ),
              )
            : SizedBox(),
        Column(
          children: [
            SizedBox(height: 10),
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 0,
                          borderSide:
                              BorderSide(color: kBlackColor.withOpacity(0.2)))),
                  value: selectedDuration,
                  items: durationFilter
                      .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e,
                              style: textTheme(context).headlineMedium)))
                      .toList(),
                  onChanged: ((value) =>
                      setState(() => selectedDuration = value.toString()))),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('AND', style: textTheme(context).displaySmall),
              ],
            ),
            SizedBox(height: 10),
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 0,
                          borderSide:
                              BorderSide(color: kBlackColor.withOpacity(0.2)))),
                  value: selectedType,
                  items: typeFilter
                      .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e,
                              style: textTheme(context).headlineMedium)))
                      .toList(),
                  onChanged: ((value) =>
                      setState(() => selectedType = value.toString()))),
            ),
            SizedBox(height: 10),
          ],
        ),
        SizedBox(height: 10),
        showLoader
            ? Container(
                width: getScreenWidth(context),
                child: Center(
                  child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator()),
                ),
              )
            : MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: BorderSide(color: kBlackColor)),
                onPressed: () async {
                  print("Ceck");
                  if (widget.filterType == "news") {
                    setState(() => showLoader = true);
                    await db
                        .newsFilterSearch(_keywords.text ?? '', getNewsOrder(),
                            getNewsStart())
                        .then((value) {
                      setState(() => showLoader = true);
                      getPop(context);
                      setState(() {
                        final db =
                            Provider.of<AppDataHandler>(context, listen: false);
                        db.notifyListeners();
                      });
                    });
                  } else if (widget.filterType == "forum") {
                    setState(() => showLoader = true);
                    await db
                        .forumFilterSearch(_keywords.text ?? '', getNewsOrder(),
                            getNewsStart())
                        .then((value) {
                      setState(() => showLoader = true);
                      getPop(context);
                      setState(() {
                        final db =
                            Provider.of<AppDataHandler>(context, listen: false);
                        db.notifyListeners();
                      });
                    });
                  } else {
                    setState(() => showLoader = true);
                    await db
                        .multimediaFilterSearch(_keywords.text ?? '',
                            getNewsOrder(), getNewsStart())
                        .then((value) {
                      setState(() => showLoader = true);
                      getPop(context);
                      setState(() {
                        final db =
                            Provider.of<AppDataHandler>(context, listen: false);
                        db.notifyListeners();
                      });
                    });
                  }
                },
                child: Text("GO", style: textTheme(context).displaySmall))
      ],
    );
  }
}

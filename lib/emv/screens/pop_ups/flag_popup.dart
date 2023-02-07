import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../commons/toast.dart';
import '../../handlers/data_handler.dart';

class FlagPopUpView extends StatefulWidget {
  String title;
  String blogId;
  int type;
  FlagPopUpView(
      {Key key, @required this.title, @required this.blogId, this.type = 0})
      : super(key: key);

  @override
  State<FlagPopUpView> createState() => _FlagPopUpViewState();
}

class _FlagPopUpViewState extends State<FlagPopUpView> {
  final TextEditingController _reasonCtrl = TextEditingController();
  List<String> reasons = [
    "Innappropriate/Offensive",
    "Link doesn't work",
    "Irrelevant",
    "Duplicate",
    "Other Reason"
  ];

  String selectedReason = 'Innappropriate/Offensive';

  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SimpleDialog(
            title: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: Text(
                      widget.title,
                      style: textTheme(context).displaySmall,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: kBlackColor),
                  child: IconButton(
                      onPressed: () => getPop(context),
                      icon: const Icon(
                        Icons.close,
                        size: 15,
                        color: kWhiteColor,
                      )),
                )
              ],
            ),
            children: [
              ...reasons
                  .map((e) => Row(
                        children: [
                          IconButton(
                              onPressed: () =>
                                  setState(() => selectedReason = e),
                              icon: e == selectedReason
                                  ? const Icon(
                                      Icons.check_box,
                                      color: kGreenColor,
                                    )
                                  : const Icon(Icons.check_box_outline_blank)),
                          Text(
                            e,
                            style: textTheme(context).headlineMedium,
                          )
                        ],
                      ))
                  .toList(),
              selectedReason == "Other Reason"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _reasonCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kBlackColor.withOpacity(0.1)))),
                      ),
                    )
                  : const SizedBox(),
              putHeight(10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    submitting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : MaterialButton(
                            color: kDefaultColor,
                            onPressed: () => onSubmit(),
                            child: Text(
                              "Submit",
                              style: textTheme(context)
                                  .headlineMedium
                                  ?.copyWith(color: kWhiteColor),
                            )),
                  ],
                ),
              )
            ]),
      ],
    );
  }

  onSubmit() async {
    debugPrint(prefs.getString("authToken").toString());
    final db = Provider.of<AppDataHandler>(context, listen: false);
    setState(() => submitting = true);
    await db.submitNewsFlag(getFlagform(), widget.type).then((value) {
      if (value) {
        toast("Flag submitted successfully");
        getPop(context);
      } else {
        toast("Unable to process flag request. try again after some time");
      }
      setState(() => submitting = false);
    });
  }

  Map<String, String> getFlagform() {
    Map<String, String> json = {
      "flag_type": "blog",
      "flag_type_id": widget.blogId,
      "flag_id": getFlagId().toString(),
      "other_reason": selectedReason == "Other Reason" ? _reasonCtrl.text : ''
    };
    return json;
  }

  int getFlagId() {
    switch (selectedReason) {
      case "Innappropriate/Offensive":
        return 1;
      case "Link doesn't work":
        return 3;
      case "Irrelevant":
        return 4;
      case "Other Reason":
        return 0;

      default:
        return 2;
    }
  }
}

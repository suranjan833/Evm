import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/custom_text_field.dart';
import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../commons/toast.dart';
import '../../handlers/data_handler.dart';

class CreatForumView extends StatefulWidget {
  String type;
  CreatForumView({Key key, @required this.type}) : super(key: key);

  @override
  State<CreatForumView> createState() => _CreatForumViewState();
}

class _CreatForumViewState extends State<CreatForumView> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  bool posting = false;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Expanded(
                child: SizedBox(
                    child: Text("Create a topic",
                        style: textTheme(context).displaySmall))),
            Container(
              margin: const EdgeInsets.only(left: 10),
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: kBlackColor),
              child: IconButton(
                  onPressed: () => getPop(context),
                  icon: const Icon(Icons.close, size: 15, color: kWhiteColor)),
            )
          ],
        ),
        children: [
          Container(width: getScreenWidth(context)),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: CustomTextField(
              shrink: true,
              controller: _titleCtrl,
              hint: "Title",
              showBorder: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: CustomTextField(
              maxLine: 4,
              controller: _descCtrl,
              hint: "Description",
              showBorder: true,
            ),
          ),
          putHeight(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                posting
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10)),
                            backgroundColor:
                                MaterialStateProperty.all(kDefaultColor)),
                        onPressed: () async {
                          if (validateForm()) {
                            setState(() => posting = true);
                            var value =
                                await db.postForum(getForm(db.newsModel));
                            value
                                ? {
                                    toast("Successfully Posted"),
                                    await db.fetchForums(),
                                    getPop(context)
                                  }
                                : toast("Could not create forum. try again");
                            setState(() => posting = false);
                          }
                        },
                        child: Text("Save",
                            style: textTheme(context)
                                .headlineMedium
                                ?.copyWith(color: kWhiteColor)))
              ],
            ),
          )
        ]);
  }

  bool validateForm() {
    if (_titleCtrl.text.isEmpty || _descCtrl.text.isEmpty) {
      toast("Field can not be empty");
      return false;
    } else {
      return true;
    }
  }

  Map<String, String> getForm(String model) {
    Map<String, String> json = {
      "question": _titleCtrl.text,
      "description": _descCtrl.text,
      "type": widget.type,
      "model": model
    };
    return json;
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/custom_text_field.dart';
import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../commons/toast.dart';
import '../../handlers/data_handler.dart';

class UploadMediaView extends StatefulWidget {
  const UploadMediaView({Key key}) : super(key: key);

  @override
  State<UploadMediaView> createState() => _UploadMediaViewState();
}

class _UploadMediaViewState extends State<UploadMediaView> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<String> mediatype = ["Image", "Video"];
  String selectedMediaType = "Image";

  bool posting = false;

  XFile pickedFile;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Expanded(
              child: SizedBox(
                  child: Text("Add new Multimedia",
                      style: textTheme(context).displaySmall))),
          Container(
            margin: const EdgeInsets.only(left: 10),
            height: 30,
            width: 30,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: kBlackColor),
            child: IconButton(
                onPressed: () => getPop(context),
                icon: const Icon(Icons.close, size: 15, color: kWhiteColor)),
          )
        ],
      ),
      children: [
        Container(width: getScreenWidth(context)),
        const Divider(),
        Text.rich(TextSpan(
            text: "Note: ",
            style: textTheme(context)
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text:
                      "If you upload both image and video, by default we display image",
                  style: textTheme(context)
                      .headlineMedium
                      ?.copyWith(color: kBlackColor.withOpacity(0.4)))
            ])),
        putHeight(20),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: CustomTextField(
              shrink: true,
              controller: _titleCtrl,
              hint: "Title",
              showBorder: true),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: CustomTextField(
              maxLine: 4,
              controller: _descCtrl,
              hint: "Description",
              showBorder: true),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: kBlackColor.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    value: selectedMediaType,
                    borderRadius: BorderRadius.circular(10),
                    isExpanded: true,
                    items: mediatype
                        .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e,
                                style: textTheme(context).headlineMedium)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => selectedMediaType = v.toString())),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$selectedMediaType*",
                style: textTheme(context).headlineMedium),
            MaterialButton(
                color: kBlackColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () async {
                  if (selectedMediaType == "Image") {
                    var pickedImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                    pickedImage != null
                        ? setState(() => pickedFile = pickedImage)
                        : null;
                  } else {
                    var pickedVideo =
                        await _picker.pickVideo(source: ImageSource.gallery);
                    pickedVideo != null
                        ? setState(() => pickedFile = pickedVideo)
                        : null;
                  }
                },
                child: Text(
                  "Choose File ",
                  style: textTheme(context)
                      .headlineMedium
                      ?.copyWith(color: kWhiteColor),
                ))
          ],
        ),
        pickedFile == null
            ? const SizedBox()
            : Text(pickedFile.path.split("/").last),
        putHeight(20),
        Row(
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
                        // var value = await db.postMedia(
                        //     getform(db.getNewsType, db.newsModel,pickedFile.path),
                        //     selectedMediaType,
                        //     pickedFile.path);
                        var value = await db.postMedia1(
                            _titleCtrl.text,
                            _descCtrl.text,
                            db.getNewsType,
                            db.getfilterType(),
                            pickedFile.path,
                            selectedMediaType == "Image" ? true : false);

                        value
                            ? {
                                toast("Successfully Posted"),
                                await db.fetchMultimedia(),
                                getPop(context)
                              }
                            : toast("Could not post media. try again");
                        setState(() => posting = false);
                      }
                    },
                    child: Text("Submit",
                        style: textTheme(context)
                            .headlineMedium
                            ?.copyWith(color: kWhiteColor)))
          ],
        )
      ],
    );
  }

  bool validateForm() {
    if (_titleCtrl.text.isEmpty || _descCtrl.text.isEmpty) {
      toast("Please enter data");
      return false;
    } else if (pickedFile == null) {
      toast("Please choose file first");
      return false;
    } else {
      return true;
    }
  }

  Map<String, String> getform(String id, String model, String path) {
    Map<String, String> json = {
      "title": _titleCtrl.text,
      "description": _descCtrl.text,
      "type": id,
      "model": model,
      "image": path
    };
    return json;
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/custom_text_field.dart';
import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../commons/toast.dart';
import '../../handlers/data_handler.dart';

class EnquirFormView extends StatefulWidget {
  String carId;
  EnquirFormView({Key key, @required this.carId}) : super(key: key);

  @override
  State<EnquirFormView> createState() => _EnquirFormViewState();
}

class _EnquirFormViewState extends State<EnquirFormView> {
  final TextEditingController _fNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _subjectCtrl = TextEditingController();
  final TextEditingController _msgCtrl = TextEditingController();

  bool _posting = false;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(10),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: SizedBox(
                      child: Text("Enquiry Now",
                          style: textTheme(context).displaySmall))),
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: kBlackColor),
                  child: IconButton(
                      onPressed: () => getPop(context),
                      icon: const Icon(Icons.close,
                          size: 15, color: kWhiteColor)))
            ],
          ),
          const Divider()
        ],
      ),
      children: [
        Container(
          width: getScreenWidth(context),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: CustomTextField(
            showBorder: true,
            controller: _fNameCtrl,
            hint: "First Name",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: CustomTextField(
            showBorder: true,
            controller: _lastNameCtrl,
            hint: "Last Name",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: CustomTextField(
            showBorder: true,
            controller: _emailCtrl,
            hint: "Email",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: CustomTextField(
            showBorder: true,
            controller: _phoneCtrl,
            hint: "Phone No",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: CustomTextField(
            showBorder: true,
            controller: _subjectCtrl,
            hint: "Subject",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: CustomTextField(
            maxLine: 5,
            showBorder: true,
            controller: _msgCtrl,
            hint: "Message",
          ),
        ),
        putHeight(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10)),
                    backgroundColor: MaterialStateProperty.all(
                        kBlackColor.withOpacity(0.3))),
                onPressed: () => getPop(context),
                child: Text("Close", style: textTheme(context).headlineMedium)),
            putWidth(15),
            TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10)),
                    backgroundColor: MaterialStateProperty.all(kDefaultColor)),
                onPressed: () async {
                  if (validateform()) {
                    setState(() => _posting = true);
                    await db.sendCarEnquiry(getForm()).then((value) => value
                        ? {
                            getPop(context),
                            toast("Your enquiry sent successfully")
                          }
                        : toast("Unable to post your enquiry. try again"));
                    setState(() => _posting = false);
                  }
                },
                child: _posting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                            child:
                                CircularProgressIndicator(color: kWhiteColor)))
                    : Text("Submit",
                        style: textTheme(context)
                            .headlineMedium
                            ?.copyWith(color: kWhiteColor))),
          ],
        )
      ],
    );
  }

  bool validateform() {
    if (_fNameCtrl.text.isEmpty ||
        _lastNameCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _phoneCtrl.text.isEmpty ||
        _subjectCtrl.text.isEmpty ||
        _msgCtrl.text.isEmpty) {
      toast("Please fill all fields");
      return false;
    } else {
      return true;
    }
  }

  Map<String, String> getForm() {
    Map<String, String> json = {
      "car_id": widget.carId,
      "first_name": _fNameCtrl.text,
      "last_name": _lastNameCtrl.text,
      "email": _emailCtrl.text,
      "phone": _phoneCtrl.text,
      "subject": _subjectCtrl.text,
      "message": _msgCtrl.text
    };
    return json;
  }

  disposeController() {
    _fNameCtrl.clear();
    _lastNameCtrl.clear();
    _emailCtrl.clear();
    _phoneCtrl.clear();
    _subjectCtrl.clear();
    _msgCtrl.clear();
  }
}

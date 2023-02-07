import 'package:flutter/material.dart';

import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';

class EnquiryDialogView extends StatefulWidget {
  const EnquiryDialogView({Key key}) : super(key: key);

  @override
  State<EnquiryDialogView> createState() => _EnquiryDialogViewState();
}

class _EnquiryDialogViewState extends State<EnquiryDialogView> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        children: [
          Expanded(
              child: SizedBox(
                  child: Text("Enquiry Now",
                      style: textTheme(context).headline3))),
          Container(
              margin: const EdgeInsets.only(left: 10),
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: kBlackColor),
              child: IconButton(
                  onPressed: () => getPop(context),
                  icon: const Icon(Icons.close, size: 15, color: kWhiteColor)))
        ],
      ),
    );
  }
}

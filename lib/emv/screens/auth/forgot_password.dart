import 'package:flutter/material.dart';

import '../../base_widgets/custom_flat_button.dart';
import '../../base_widgets/custom_text_field.dart';
import '../../commons/helper_functions.dart';
import '../../commons/icons_logo_strings.dart';
import '../../commons/stylesheet.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        foregroundColor: kBlackColor,
        title: Text(
          "Password reset",
          style: textTheme(context).displaySmall.copyWith(color: kDefaultColor),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            putHeight(30),
            CustomTextField(
              hint: "Enter email",
              preFixIcon: emailIcon,
            ),
            putHeight(30),
            CustomExpandedButton(
              label: "SUBMIT",
              backgroundColor: kBlackColor,
            )
          ],
        ),
      )),
    );
  }
}

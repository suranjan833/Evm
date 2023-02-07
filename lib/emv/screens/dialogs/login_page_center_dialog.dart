import 'package:flutter/material.dart';

import '../../base_widgets/custom_flat_button.dart';
import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../auth/login.dart';

class LoginPageCenterDialog extends StatelessWidget {
  const LoginPageCenterDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Not logged in",
              style: textTheme(context).headline2?.copyWith(color: kredColor)),
          putHeight(10),
          Text("You must be logged in to access this page",
              style:
                  textTheme(context).headline4?.copyWith(color: kBlackColor)),
          putHeight(30),
          CustomExpandedButton(
              label: "Login", ontap: () => pushTo(context, LoginScreen()))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../auth/login.dart';
import '../auth/signup.dart';

class ShowLoginDialog extends StatefulWidget {
  const ShowLoginDialog({Key key}) : super(key: key);

  @override
  State<ShowLoginDialog> createState() => _ShowLoginDialogState();
}

class _ShowLoginDialogState extends State<ShowLoginDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text(
        "Alert!",
        style: Theme.of(context).textTheme.headline4,
      ),
      content: Text(
        "You must be logged in to access this feature",
        style: Theme.of(context).textTheme.headline5,
      ),
      actions: [
        TextButton(
            onPressed: () => getPop(context),
            child: Text(
              "Cancel",
              style: theme.headline4?.copyWith(color: kBlackColor),
            )),
        TextButton(
            onPressed: () => pushTo(context, const SignUpScreen()),
            child: Text(
              "Register",
              style: theme.headline4?.copyWith(color: kDefaultColor),
            )),
        TextButton(
            onPressed: () => pushTo(context, LoginScreen()),
            child: Text(
              "Login",
              style: theme.headline4?.copyWith(color: kGreenColor),
            )),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../emv/commons/helper_functions.dart';
import '../emv/screens/dashboard.dart';
import '../helpers/shared_value_helper.dart';

class CommonFunctions {
  BuildContext context;

  CommonFunctions(this.context);

  appExitDialog() {
    showDialog(
        context: context,
        builder: (context) => Directionality(
              textDirection:
                  app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
              child: AlertDialog(
                content:
                    Text(AppLocalizations.of(context).home_screen_close_app),
                actions: [
                  TextButton(
                      onPressed: () {
                        pushAndRemove(context, DashboardScreen());
                      },
                      child: Text(AppLocalizations.of(context).common_yes)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context).common_no)),
                ],
              ),
            ));
  }
}

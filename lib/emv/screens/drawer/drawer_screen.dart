import 'package:flutter/material.dart';

import '../../app_config.dart';
import '../../commons/helper_functions.dart';
import '../../commons/icons_logo_strings.dart';
import '../../commons/stylesheet.dart';
import '../dashboard.dart';
import '../webview.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final List<String> _buttonList = [
    "Home",
    "About EMV",
    "Suggestions",
    // "Get Car Insurance",
    // "Get Car Loans",
    "Contact Us",
    "Terms of Use",
    "Privacy Policy"
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            putHeight(30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(appLogo),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: kDefaultColor,
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buttonList
                    .map((e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                if (e == "About EMV") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebviewBrowser(
                                                url:
                                                    "https://www.elonmuskvision.com/app-about",
                                                title: "About EMV",
                                              )));
                                }
                                if (e == "Contact Us") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebviewBrowser(
                                                url:
                                                    "https://www.elonmuskvision.com/app-contact",
                                                title: "Contact Us",
                                              )));
                                }
                                if (e == "Suggestions") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebviewBrowser(
                                                url:
                                                    "https://www.elonmuskvision.com/app-suggestion",
                                                title: "Suggestions",
                                              )));
                                }
                                if (e == "Terms of Use") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebviewBrowser(
                                                url:
                                                    "https://www.elonmuskvision.com/app-terms-and-conditions",
                                                title: "Terms of Use",
                                              )));
                                }
                                if (e == "Privacy Policy") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebviewBrowser(
                                                url:
                                                    "https://www.elonmuskvision.com/app-privacy-policy",
                                                title: "Privacy Policy",
                                              )));
                                }
                                if (e == "Home") {
                                  pushTo(context, DashboardScreen());
                                }
                              },
                              child: _drawerButton(
                                  theme, _buttonList, _buttonList.indexOf(e)),
                            ),
                            const Divider(
                              thickness: 1,
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _drawerButton(TextTheme theme, List<String> values, int i) {
    return ListTile(
      minVerticalPadding: 2,
      // onTap: () => _getNavigation(values[i]),
      title: Text(
        values[i],
        style: theme.headlineMedium,
      ),

      leading: Icon(Icons.arrow_forward),
    );
  }

  String _getButtonIcon(String buttonValue) {
    switch (buttonValue) {
      case "Home":
        return homeIcon;
      case "About EMV":
        return aboutIcon;
      case "Suggestions":
        return suggestionIcon;
      case "Shop Now":
        return shopIcon;
      case "Browse Used Teslas":
        return userCarIcon;
      case "Tesla Car Loans":
        return loanIcon;
      case "Tesla Car Insurance":
        return insuranceIcon;
      case "Contact Us":
        return contactIcon;

      default:
        return userIcon;
    }
  }

  // "Home",
  //   "About EMV",
  //   "Suggestions",
  //   "Shop Now",
  //   "Browse Used Teslas",
  //   "Tesla Car Loans",
  //   "Tesla Car Insurance"
  //   "Contact Us",

  _getNavigation(String buttonValue) {
    switch (buttonValue) {
      case "Home":
        return pushTo(context, DashboardScreen());
      case "About EMV":
        return null;
      case "Suggestions":
        return null;
      case "Shop Now":
        return null;
      case "Browse Used Teslas":
        return pushTo(context, DashboardScreen(viewIndex: 0));
      case "Tesla Car Loans":
        return null;
      case "Tesla Car Insurance":
        return null;
      case "Contact Us":
        return null;

      default:
        return null;
    }
  }
}

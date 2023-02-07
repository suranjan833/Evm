import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

import '../handlers/data_handler.dart';

// Component Size Handlers
double getAppbarHeight(BuildContext context) => AppBar().preferredSize.height;
double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;
double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

// Empty space handlers
SizedBox putHeight(double height) => SizedBox(height: height);
SizedBox putWidth(double width) => SizedBox(width: width);

// Test Style theme handler
TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;

// Navigation Handlers
getPop(BuildContext context) => Navigator.of(context).pop();
pushTo(BuildContext context, Widget child) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => child));
pushAndRemove(BuildContext context, Widget child) =>
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => child), (route) => false);
pushAndReplace(BuildContext context, Widget child) => Navigator.of(context)
    .pushReplacement(MaterialPageRoute(builder: (_) => child));

// Keyboard Focus Handlers
unfocus(BuildContext context) => FocusScope.of(context).unfocus();
requestFocus(BuildContext context) => FocusScope.of(context).requestFocus();

// Share activity Handler
Future<void> share({String link = '', String title = ''}) async {
  await FlutterShare.share(
      title: title,
      text: 'Example share text',
      linkUrl: link,
      chooserTitle: 'Example Chooser Title');
}

authNavigate(Widget child, BuildContext context) {
  if (prefs.getString("authToken") == null) {
    pushTo(context, child);
  } else {
    null;
  }
}

showMiniLoader(double size) => Image.asset(
      "assets/loading.gif",
      height: size,
    );

enum GetMediaType { news, forum, multimedia, chat }

String getDataModel(String value) {
  switch (value) {
    case "Gigafactory":
      return "ENERGY-GIGAFACTORY";
    case "Solar Panels/Roof":
      return "ENERGY-SOLARPANELSROOF";
    case "Powerwall":
      return "ENERGY-POWERWALL";
    case "Tesla Motors":
      return "MOTOR";
    case "Tesla Energy":
      return "ENERGY";
    case "Optimus":
      return "OPTIMUS";
    case "Model S":
      return "Model S";
    case "Model E":
      return "Model E";
    case "Model X":
      return "Model X";
    case "Model Y":
      return "Model Y";
    case "Roadster":
      return "Roadster";
    case "Semi":
      return "Semi";
    case "Cybertruck":
      return "Cybertruck";
    case "Falcon 9":
      return "FALCON 9";
    case "Falcon Heavy":
      return "FALCON HEAVY";
    case "Dragon":
      return "DRAGON";
    case "Starship":
      return "STARSHIP";
    case "Starlink":
      return "STARLINK";
    case "The Boring Company":
      return "Boring Company";
    case "Hyperloop":
      return "Hyperloop";
    case "Artificial Intelligence":
      return "Artificial Intelligence";
    default:
      return '';
  }
}

String getChatModel(String newsType, String value) {
  print(newsType.toString());
  print("newstypr " + value);
  switch (value) {
    case "Gigafactory":
      return "8";
    case "ENERGY-GIGAFACTORY":
      return "8";
    case "Solar Panels/Roof":
      return "16";
    case "ENERGY-SOLARPANELSROOF":
      return "16";
    case "Powerwall":
      return "17";
    case "ENERGY-POWERWALL":
      return "17";
    case "tesla-energy":
      return "ENERGY";
    case "Model S":
      return "1";
    case "Model E":
      return "2";
    case "Model X":
      return "3";
    case "Model Y":
      return "4";
    case "Roadster":
      return "5";
    case "Semi":
      return "6";
    case "Cybertruck":
      return "7";
    case "FALCON 9":
      return "9";
    case "FALCON HEAVY":
      return "10";
    case "DRAGON":
      return "11";
    case "STARSHIP":
      return "12";
    case "STARLINK":
      return "13";
    case "Artificial Intelligence":
      return "24";
    case "Boring Company":
      return "25";
    case "Hyperloop":
      return "26";
    default:
      return newsType == '1' && value == "All"
          ? '19'
          : newsType == '2' && value == "All"
              ? "20"
              : "14";
  }
}
// String getChatModel(String newsType, String value) {
//   print(newsType.toString());
//   print("newstypr "+value);
//   switch (value) {
//     case "Gigafactory":
//       return "8";
//     case "GIGAFACTORY":
//       return "8";
//     case "Solar Panels/Roof":
//       return "16";
//     case "ENERGY-SOLARPANELSROOF":
//       return "16";
//     case "Powerwall":
//       return "17";
//     case "ENERGY-POWERWALL":
//       return "17";
//     case "tesla-energy":
//       return "ENERGY";
//     case "Model S":
//       return "1";
//     case "Model E":
//       return "2";
//     case "Model X":
//       return "3";
//     case "Model Y":
//       return "4";
//     case "Roadster":
//       return "5";
//     case "Semi":
//       return "6";
//     case "Cybertruck":
//       return "7";
//     case "Falcon 9":
//       return "9";
//     case "Falcon Heavy":
//       return "10";
//     case "Dragon":
//       return "11";
//     case "Starship":
//       return "12";
//     case "Starlink":
//       return "13";
//     default:
//       return newsType == '1' && value == "All"
//           ? '19'
//           : newsType == '2' && value == "All"
//           ? "20"
//           : "14";
//   }
// }

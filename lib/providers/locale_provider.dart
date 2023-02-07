import 'package:flutter/material.dart';

import '../helpers/shared_value_helper.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale;
  Locale get locale {
    //print("app_mobile_language.isEmpty${app_mobile_language.$.isEmpty}");
    return _locale =
        Locale(app_mobile_language.$ == '' ? "en" : app_mobile_language.$, '');
  }

  void setLocale(String code) {
    _locale = Locale(code, '');
    notifyListeners();
  }
}

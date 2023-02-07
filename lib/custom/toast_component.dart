import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:toast/toast.dart';

import '../my_theme.dart';

class ToastComponent {
  static showDialog(String msg, {duration = 0, gravity = 0}) {
    ToastContext().init(OneContext().context);
    Toast.show(msg,
        duration: duration != 0 ? duration : Toast.lengthShort,
        gravity: gravity != 0 ? gravity : Toast.bottom,
        backgroundColor: Color.fromRGBO(239, 239, 239, .9),
        textStyle: TextStyle(color: MyTheme.font_grey),
        border: Border(
            top: BorderSide(
              color: Color.fromRGBO(203, 209, 209, 1),
            ),
            bottom: BorderSide(
              color: Color.fromRGBO(203, 209, 209, 1),
            ),
            right: BorderSide(
              color: Color.fromRGBO(203, 209, 209, 1),
            ),
            left: BorderSide(
              color: Color.fromRGBO(203, 209, 209, 1),
            )),
        backgroundRadius: 6);
  }
}

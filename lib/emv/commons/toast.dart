import 'package:emv/emv/commons/stylesheet.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast(msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor: kDefaultColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

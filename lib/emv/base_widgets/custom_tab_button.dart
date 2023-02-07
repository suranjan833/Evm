import 'package:flutter/material.dart';

import '../commons/helper_functions.dart';
import '../commons/stylesheet.dart';

class CustomTabButton extends StatelessWidget {
  String path;
  Color buttonColor;
  Function onTap;
  int length;
  bool isActive;
  CustomTabButton(
      {Key key,
      @required this.path,
      @required this.buttonColor,
      this.onTap,
      this.isActive = false,
      this.length = 4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap != null ? onTap() : null,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(3),
          height: 40,
          width: (getScreenWidth(context) - (4 * length)) / length,
          decoration: BoxDecoration(
            boxShadow: [
              isActive
                  ? BoxShadow(
                      color: kBlackColor, blurRadius: 3, offset: Offset(4, 5))
                  : BoxShadow()
            ],
            color: buttonColor,
            border: isActive ? Border.all(color: kWhiteColor) : null,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Image.asset(
              path,
              color: kWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}

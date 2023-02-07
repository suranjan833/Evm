import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../commons/stylesheet.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String hint;
  Function(String) onValueChange;
  String suffixIcon;
  String preFixIcon;
  Color suffixColor;
  Color prefixColor;
  bool shrink;
  int maxLine;
  bool showBorder;
  CustomTextField(
      {Key key,
      this.hint = '',
      this.suffixIcon = '',
      this.preFixIcon = '',
      this.suffixColor = kDefaultColor,
      this.prefixColor = kDefaultColor,
      this.showBorder = false,
      this.onValueChange,
      this.maxLine = 1,
      this.shrink = false,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      height: shrink ? 50 : null,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: showBorder
                  ? kBlackColor.withOpacity(0.2)
                  : Colors.transparent)),
      child: TextField(
          onChanged: onValueChange,
          maxLines: maxLine,
          controller: controller,
          decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  theme.headline4.copyWith(color: kBlackColor.withOpacity(0.3)),
              suffixIcon: suffixIcon == ''
                  ? null
                  : IconButton(
                      onPressed: null,
                      icon: SvgPicture.asset(
                        suffixIcon,
                        width: 20,
                        color: suffixColor,
                      )),
              prefixIcon: preFixIcon == ''
                  ? null
                  : IconButton(
                      onPressed: null,
                      icon: SvgPicture.asset(
                        preFixIcon,
                        color: prefixColor,
                      )),
              border: showBorder
                  ? const OutlineInputBorder(borderSide: BorderSide.none)
                  : null)),
    );
  }
}

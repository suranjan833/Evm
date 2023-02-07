import 'package:flutter/material.dart';

import '../commons/stylesheet.dart';

class CustomExpandedButton extends StatelessWidget {
  bool isFlexible;
  String label;
  Color labelColor;
  Color backgroundColor;
  Function ontap;
  CustomExpandedButton(
      {Key key,
      this.isFlexible = false,
      this.label = 'Add Label',
      this.labelColor = kWhiteColor,
      this.backgroundColor = kDefaultColor,
      this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isFlexible
            ? Flexible(
                child: _button(theme),
              )
            : Expanded(
                child: _button(theme),
              )
      ],
    );
  }

  Container _button(TextTheme theme) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: backgroundColor),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: ontap != null ? () => ontap() : null,
        child: Text(
          label,
          style: theme.displaySmall.copyWith(color: labelColor),
        ),
      ),
    );
  }
}

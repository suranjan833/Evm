import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../commons/helper_functions.dart';
import '../../../commons/stylesheet.dart';

class NewsFooterSection extends StatelessWidget {
  String icon;
  String label;
  Color iconColor;
  NewsFooterSection(
      {Key key,
      @required this.icon,
      @required this.label,
      this.iconColor = kBlackColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      color: kWhiteColor,
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 12,
            color: iconColor,
          ),
          putHeight(5),
          Text(
            label,
            style: theme.headline5.copyWith(color: iconColor),
          ),
          putHeight(3),
        ],
      ),
    );
  }
}

class NewsFooterHorizontal extends StatelessWidget {
  String text;
  IconData icon;
  NewsFooterHorizontal({
    Key key,
    @required this.text,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return getScreenWidth(context) < 320
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: kBlackColor.withOpacity(0.4),
              ),
              Text(
                text,
                style: theme.headline5,
              )
            ],
          )
        : TextButton.icon(
            onPressed: null,
            icon: Icon(
              icon,
              size: 15,
              color: kBlackColor.withOpacity(0.4),
            ),
            label: Text(
              text,
              style: theme.headline5,
            ));
  }
}

import 'package:flutter/material.dart';

import 'helper_functions.dart';

class EmptyDataView extends StatelessWidget {
  const EmptyDataView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/emv_assets/no_result.png",
            width: getScreenWidth(context) * 0.4,
          ),
          Text(
            "Nothing found",
            style: textTheme(context).headlineMedium,
          ),
        ],
      ),
    );
  }
}

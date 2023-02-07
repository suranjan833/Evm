import 'package:emv/emv/commons/stylesheet.dart';
import 'package:flutter/material.dart';

import 'helper_functions.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenHeight(context),
      width: getScreenWidth(context),
      color: kBlackColor.withOpacity(0.4),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: kDefaultColor,
                  ),
                ),
                putHeight(10),
                Text(
                  "Loading..",
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

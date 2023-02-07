import 'package:flutter/material.dart';

class ShopNowview extends StatefulWidget {
  const ShopNowview({Key key}) : super(key: key);

  @override
  State<ShopNowview> createState() => _ShopNowviewState();
}

class _ShopNowviewState extends State<ShopNowview> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("This is shoping Screen"),
      ),
    );
  }
}

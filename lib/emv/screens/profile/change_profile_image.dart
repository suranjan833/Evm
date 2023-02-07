import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChangeProfileImage extends StatefulWidget {
  const ChangeProfileImage({Key key}) : super(key: key);

  @override
  State<ChangeProfileImage> createState() => _ChangeProfileImageState();
}

class _ChangeProfileImageState extends State<ChangeProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Profile Picture"),
      ),
      body: WebView(
        initialUrl: "https://www.elonmuskvision.com/",
        javascriptMode: JavascriptMode.unrestricted,
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
          if (progress<100) {
            CircularProgressIndicator();
          }
          
        },
      ),
    );
  }
}

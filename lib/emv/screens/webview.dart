import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewBrowser extends StatefulWidget {
  final String url;
  final String title;
  const WebviewBrowser({@required this.url,@required this.title});

  @override
  State<WebviewBrowser> createState() => _WebviewBrowserState();
}

class _WebviewBrowserState extends State<WebviewBrowser> {
  bool _loading=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
          body:
          // _loading?Center(child: CircularProgressIndicator(),)
          //     :
          WebView(
            onProgress: (p) {
            p <  50
          ? setState(() => _loading = true)
          : setState(() => _loading = false);
    },

    initialUrl: widget.url,
    javascriptMode: JavascriptMode.unrestricted,
    ),
    );
  }
}


import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:typed_data';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String method; // "GET" or "POST"
  final String? body;
  final Map<String, String>? headers;

  const WebViewScreen({
    Key? key,
    required this.url,
    this.method = 'GET',
    this.body,
    this.headers,
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                debugPrint('Page loading: $url');
              },
              onPageFinished: (url) {
                debugPrint('Page loaded: $url');
              },
              onWebResourceError: (error) {
                debugPrint('WebView error: ${error.description}');
              },
            ),
          );

    if (widget.method.toUpperCase() == 'POST' && widget.body != null) {
      _controller.loadRequest(
        Uri.parse(widget.url),
        method: LoadRequestMethod.post,
        headers:
            widget.headers ??
            {'Content-Type': 'application/x-www-form-urlencoded'},
        body: Uint8List.fromList(widget.body!.codeUnits),
      );
    } else {
      _controller.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStatic(),
      body: WebViewWidget(controller: _controller),
    );
  }
}

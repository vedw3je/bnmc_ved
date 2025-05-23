import 'dart:convert';
import 'dart:typed_data';
import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String method; // "GET" or "POST"
  final String phoneNumber;
  final String email;
  final Map<String, String>? headers;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.phoneNumber,
    required this.email,
    this.method = 'POST',
    this.headers,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController _webViewController;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStatic(),
      body: FutureBuilder<URLRequest>(
        future: _buildUrlRequest(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: snapshot.data!,
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                      useOnDownloadStart: true,
                      mediaPlaybackRequiresUserGesture: false,
                    ),
                  ),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      _isLoading = true;
                    });
                    debugPrint("Loading: $url");
                  },
                  onLoadStop: (controller, url) {
                    setState(() {
                      _isLoading = false;
                    });
                    debugPrint("Loaded: $url");
                  },
                  onLoadError: (controller, url, code, message) {
                    debugPrint("WebView error: $message");
                  },
                  onConsoleMessage: (controller, message) {
                    debugPrint("Console: ${message.message}");
                  },
                ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<URLRequest> _buildUrlRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final uniqueId = prefs.getString('unique_id') ?? '';
    final msg = '$uniqueId~${widget.phoneNumber}~${widget.email}';
    final method = widget.method.toUpperCase();

    if (method == 'POST') {
      final postData = Uint8List.fromList(utf8.encode("msg=$msg"));
      return URLRequest(
        url: WebUri.uri(Uri.parse(widget.url)),
        method: 'POST',
        headers:
            widget.headers ??
            {'Content-Type': 'application/x-www-form-urlencoded'},
        body: postData,
      );
    } else {
      return URLRequest(
        url: WebUri.uri(Uri.parse(widget.url)),
        method: 'GET',
        headers: widget.headers,
      );
    }
  }
}

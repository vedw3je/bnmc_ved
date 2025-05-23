import 'dart:convert';
import 'dart:typed_data';

import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayBillInAppWebView extends StatefulWidget {
  final String url;
  final String phoneNumber;
  final String email;
  final String propertyNumber;

  const PayBillInAppWebView({
    super.key,
    required this.url,
    required this.phoneNumber,
    required this.email,
    required this.propertyNumber,
  });

  @override
  State<PayBillInAppWebView> createState() => _PayBillInAppWebViewState();
}

class _PayBillInAppWebViewState extends State<PayBillInAppWebView> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStatic(),
      body: FutureBuilder<String>(
        future: _getPostData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final requestData = snapshot.data!;
          final postData = Uint8List.fromList(utf8.encode("msg=$requestData"));

          return InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(Uri.parse(widget.url)),
              method: 'POST',
              body: postData,
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            ),
            // ignore: deprecated_member_use
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
              debugPrint("Loading: $url");
            },
            onLoadStop: (controller, url) {
              debugPrint("Loaded: $url");
            },
            onConsoleMessage: (controller, consoleMessage) {
              debugPrint("Console: ${consoleMessage.message}");
            },
          );
        },
      ),
    );
  }

  Future<String> _getPostData() async {
    final prefs = await SharedPreferences.getInstance();
    final uniqueId = prefs.getString('unique_id') ?? '';
    return '$uniqueId~${widget.phoneNumber}~${widget.email}~${widget.propertyNumber}';
  }
}

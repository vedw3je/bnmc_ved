import 'dart:convert';
import 'dart:developer';
import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    final prefs = await SharedPreferences.getInstance();
    final uniqueId = prefs.getString('unique_id') ?? '';
    final requestString = '$uniqueId~${widget.phoneNumber}~${widget.email}';
    log(requestString);

    // Initialize WebViewController
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..enableZoom(true)
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

    if (widget.method.toUpperCase() == 'POST') {
      // Send POST request
      final response = await http.post(
        Uri.parse(widget.url),
        headers:
            widget.headers ??
            {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'msg': requestString},
      );

      if (response.statusCode == 200) {
        // Inject the response HTML into WebView

        // Inject HTML content into WebView
        final htmlContent = response.body;
        controller.loadRequest(
          Uri.parse(
            'data:text/html;charset=utf-8,${Uri.encodeComponent(htmlContent)}',
          ),
        );
      } else {
        debugPrint('Failed to load page. Status Code: ${response.statusCode}');
      }
    } else {
      // For GET requests, simply load the URL
      await controller.loadRequest(
        Uri.parse(widget.url),
        method: LoadRequestMethod.get,
      );
    }

    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStatic(),
      body:
          _controller == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top:
                          -70.0, // Adjust this value to start from a lower point
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: WebViewWidget(controller: _controller!),
                    ),
                  ],
                ),
              ),
    );
  }
}

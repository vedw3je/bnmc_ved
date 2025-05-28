import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewBillInAppWebView extends StatefulWidget {
  final String url;
  final String mobileno;
  final String email;

  const ViewBillInAppWebView({
    super.key,
    required this.url,
    required this.mobileno,
    required this.email,
  });

  @override
  State<ViewBillInAppWebView> createState() => _ViewBillInAppWebViewState();
}

class _ViewBillInAppWebViewState extends State<ViewBillInAppWebView> {
  late InAppWebViewController _webViewController;
  @override
  void dispose() {
    _webViewController.clearCache(); // optional: clear cache if needed
    // _webViewController.loadUrl(urlRequest: URLRequest(url: WebUri('about:blank'))); // optional
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStatic(),
      body: FutureBuilder<String>(
        future: _getPostData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final postData = Uint8List.fromList(
            utf8.encode("msg=${snapshot.data}"),
          );

          return InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(Uri.parse(widget.url)),
              method: 'POST',
              body: postData,
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,

                allowFileAccessFromFileURLs: true,
                javaScriptCanOpenWindowsAutomatically: true,
                allowUniversalAccessFromFileURLs: true,
                useOnLoadResource: true,
                useOnDownloadStart: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
                allowFileAccess: true,
              ),
            ),

            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onDownloadStartRequest: (controller, request) async {
              final url = request.url.toString();
              final fileName = url.split('/').last;

              String savedDir;
              if (Platform.isAndroid) {
                // Use the public Downloads folder on Android
                savedDir = '/storage/emulated/0/Download';
              } else if (Platform.isIOS) {
                // On iOS, use the app's documents directory (no public Downloads folder)
                final directory = await getApplicationDocumentsDirectory();
                savedDir = directory.path;
              } else {
                // Fallback for other platforms if needed
                final directory = await getTemporaryDirectory();
                savedDir = directory.path;
              }

              final filePath = '$savedDir/$fileName';

              final taskId = await FlutterDownloader.enqueue(
                url: url,
                savedDir: savedDir,
                fileName: fileName,
                showNotification: true,
                openFileFromNotification: true,
              );

              Future.delayed(Duration(seconds: 1), () async {
                final result = await OpenFile.open(filePath);
                print('OpenFile result: ${result.message}');
              });

              print('Download started with task id: $taskId');
            },

            onLoadStart: (controller, url) {
              debugPrint("Loading: $url");
            },

            onLoadStop: (controller, url) {
              debugPrint("Loaded: $url");
            },

            onConsoleMessage: (controller, message) {
              debugPrint("Console: ${message.message}");
            },
          );
        },
      ),
    );
  }

  Future<String> _getPostData() async {
    final prefs = await SharedPreferences.getInstance();
    final uniqueId = prefs.getString('unique_id') ?? '';
    return '$uniqueId~${widget.mobileno}~${widget.email}';
  }
}

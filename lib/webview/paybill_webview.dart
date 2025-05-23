// import 'dart:convert';
// import 'dart:developer';
// import 'package:bncmc/commonwidgets/appbar_static.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PayBillWebView extends StatefulWidget {
//   final String url;
//   final String phoneNumber;
//   final String email;
//   final String propertyNumber;
//   final Map<String, String>? headers;

//   const PayBillWebView({
//     super.key,
//     required this.url,
//     required this.phoneNumber,
//     required this.email,
//     required this.propertyNumber,
//     this.headers,
//   });

//   @override
//   State<PayBillWebView> createState() => _PayBillWebViewState();
// }

// class _PayBillWebViewState extends State<PayBillWebView> {
//   WebViewController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     _initWebView();
//   }

//   Future<void> _initWebView() async {
//     final prefs = await SharedPreferences.getInstance();
//     final uniqueId = prefs.getString('unique_id') ?? '';
//     final requestString =
//         '$uniqueId~${widget.phoneNumber}~${widget.email}~${widget.propertyNumber}';
//     log('PayBill Request String: $requestString');

//     final controller =
//         WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..enableZoom(true)
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onPageStarted: (url) => debugPrint('Loading: $url'),
//               onPageFinished: (url) => debugPrint('Loaded: $url'),
//               onWebResourceError:
//                   (error) => debugPrint('Error: ${error.description}'),
//             ),
//           );

//     final response = await http.post(
//       Uri.parse(widget.url),
//       headers:
//           widget.headers ??
//           {'Content-Type': 'application/x-www-form-urlencoded'},
//       body: {'msg': requestString},
//     );

//     if (response.statusCode == 200) {
//       final htmlContent = response.body;
//       controller.loadRequest(
//         Uri.parse(
//           'data:text/html;charset=utf-8,${Uri.encodeComponent(htmlContent)}',
//         ),
//       );
//     } else {
//       debugPrint('Error loading page: ${response.statusCode}');
//     }

//     setState(() {
//       _controller = controller;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarStatic(),
//       body:
//           _controller == null
//               ? const Center(child: CircularProgressIndicator())
//               : SafeArea(
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: -70,
//                       left: 0,
//                       right: 0,
//                       bottom: 0,
//                       child: WebViewWidget(controller: _controller!),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }

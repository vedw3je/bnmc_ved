import 'package:bncmc/bills/screens/pay_bill_screen.dart';
import 'package:bncmc/commonwidgets/appbar_profile.dart';
import 'package:bncmc/customrouteanimation/fade_slide_route.dart';
import 'package:bncmc/home/widgets/homecards.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/webview/viewbill_receipt_webview.dart';
import 'package:bncmc/webview/webview_screen.dart';
import 'package:flutter/material.dart';

class BillsScreen extends StatefulWidget {
  final UserDetails? userDetails;
  const BillsScreen({super.key, required this.userDetails});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/drawable/ic_bg_dashboard.jpg',
          ), // Background image
          fit: BoxFit.cover, // Cover the entire screen
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarProfile(userDetails: widget.userDetails),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Space between cards
                  children: [
                    // Card for View Bills
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/ic_view_bill.png', // Path to image
                        label: 'View Bill',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (_, __, ___) => ViewBillInAppWebView(
                                    url:
                                        "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/ViewBill.aspx",
                                    email: widget.userDetails!.email,
                                    mobileno: widget.userDetails!.mobileNo,
                                  ),
                              transitionDuration: Duration(
                                milliseconds: 0,
                              ), // No animation
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16), // Space between cards
                    // Card for Pay Bills
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/ic_paybill.png', // Path to image
                        label: 'Pay Bill',
                        onTap: () {
                          Navigator.of(context).push(
                            FadeSlideRoute(
                              page: PayBillScreen(
                                userDetails: widget.userDetails,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Space between rows
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Space between cards
                  children: [
                    // Card for Download Receipt
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/ic_download_receipt.png', // Path to image
                        label: 'Download Receipt',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (_, __, ___) => ViewBillInAppWebView(
                                    url:
                                        "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/RecDownload.aspx",
                                    email: widget.userDetails!.email,
                                    mobileno: widget.userDetails!.mobileNo,
                                  ),
                              transitionDuration: Duration(
                                milliseconds: 0,
                              ), // No animation
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16), // Space between cards

                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:bncmc/bnmc_map/bnmc_map.dart';
import 'package:bncmc/commonwidgets/appbar_profile.dart';
import 'package:bncmc/customrouteanimation/fade_slide_route.dart';
import 'package:bncmc/home/widgets/homecards.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/webview/webview_screen.dart';
import 'package:flutter/material.dart';

class BhiwandiCorporationScreen extends StatefulWidget {
  final UserDetails? userDetails;
  const BhiwandiCorporationScreen({super.key, required this.userDetails});

  @override
  State<BhiwandiCorporationScreen> createState() =>
      _BhiwandiCorporationScreenState();
}

class _BhiwandiCorporationScreenState extends State<BhiwandiCorporationScreen> {
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
                    // Card for Mayor Message
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/m_msg_new.png', // Path to image
                        label: 'Mayor Message',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WebViewScreen(
                                    url:
                                        "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmMayorMsg.aspx",
                                    email: widget.userDetails!.email,
                                    phoneNumber: widget.userDetails!.mobileNo,
                                    method: "POST",
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16), // Spacer between cards
                    // Card for Commissioner Message
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/commissioner.png', // Path to image
                        label: 'Commissioner Message',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WebViewScreen(
                                    url:
                                        "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmCommissionerMsg.aspx",
                                    email: widget.userDetails!.email,
                                    phoneNumber: widget.userDetails!.mobileNo,
                                    method: "POST",
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Spacer between rows
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Space between cards
                  children: [
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/ic_elected.png', // Path to image
                        label: 'Corporator List',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WebViewScreen(
                                    url:
                                        "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmOfficerList.aspx?@=2",
                                    email: widget.userDetails!.email,
                                    phoneNumber: widget.userDetails!.mobileNo,
                                    method: "POST",
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16), // Spacer between cards

                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/ic_prabhag.png', // Path to image
                        label: 'Officers List',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WebViewScreen(
                                    url:
                                        "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmOfficerList.aspx?@=1",
                                    email: widget.userDetails!.email,
                                    phoneNumber: widget.userDetails!.mobileNo,
                                    method: "POST",
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Spacer between rows
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Space between cards
                  children: [
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/map_icon.png', // Path to image
                        label: 'BNMC MAP',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BnmcMapScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16), // Spacer between cards

                    Expanded(
                      child: CardItem(
                        imagePath: 'assets/drawable/rts.png', // Path to image
                        label: 'RTS',
                        onTap: () {
                          Navigator.of(context).push(
                            FadeSlideRoute(
                              page: WebViewScreen(
                                url:
                                    'https://nagarkaryavali.com/ANCL_RTS/App/FrmDeptServices.aspx?@=3AF849AFBCC50DDCEE31E613263F0BCC',
                                phoneNumber: widget.userDetails!.mobileNo,
                                email: widget.userDetails!.email,
                                method: "GET",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Spacer between rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // The only card, aligned to the left
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/etender.png', // Path to image
                        label: 'Etenders',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WebViewScreen(
                                    url:
                                        "https://mahatenders.gov.in/nicgep/app",
                                    email: widget.userDetails!.email,
                                    phoneNumber: widget.userDetails!.mobileNo,
                                    method: "GET",
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16), // Spacer between cards

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

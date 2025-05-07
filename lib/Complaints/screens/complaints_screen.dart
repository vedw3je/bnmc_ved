import 'package:bncmc/Complaints/Feedback/screens/feedback_screen.dart';
import 'package:bncmc/Complaints/RegisterComplaint/screen/register_complaint.dart';
import 'package:bncmc/Complaints/RegisterComplaint/screen/register_complaint_screen.dart';
import 'package:bncmc/Complaints/TrackMyComplaint/screen/track_my_complaint.dart';
import 'package:bncmc/bills/screens/pay_bill_screen.dart';
import 'package:bncmc/commonwidgets/appbar_profile.dart';
import 'package:bncmc/customrouteanimation/fade_slide_route.dart';
import 'package:bncmc/home/widgets/homecards.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/webview/webview_screen.dart';
import 'package:flutter/material.dart';

class ComplaintsScreen extends StatefulWidget {
  final UserDetails? userDetails;
  const ComplaintsScreen({super.key, required this.userDetails});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
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
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/crmnew.png', // Path to image
                        label: 'Register Your Complaint',
                        onTap: () {
                          Navigator.of(context).push(
                            FadeSlideRoute(
                              page: ComplaintFormScreen(
                                userDetails: widget.userDetails!,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16), // Space between cards

                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/track_complaint.png', // Path to image
                        label: 'Track My Complaint',
                        onTap: () {
                          Navigator.of(context).push(
                            FadeSlideRoute(
                              page: TrackMyComplaint(
                                phoneNumber: widget.userDetails!.mobileNo,
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
                            'assets/drawable/feedback.png', // Path to image
                        label: 'CRM Feedback',
                        onTap: () {
                          Navigator.of(context).push(
                            FadeSlideRoute(
                              page: FeedbackScreen(
                                userDetails: widget.userDetails!,
                              ),
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

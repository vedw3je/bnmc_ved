import 'package:bncmc/bhiwandi_corporation/bhiwandi_corporation.dart';
import 'package:bncmc/customrouteanimation/fade_slide_route.dart';
import 'package:bncmc/home/widgets/appbar.dart';
import 'package:bncmc/home/widgets/drawer.dart';
import 'package:bncmc/home/widgets/homecards.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/repository/user_details_repository.dart';
import 'package:bncmc/webview/webview_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String contactNumber;
  const HomeScreen({super.key, required this.contactNumber});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserDetails? userDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<UserDetails?> getUserDetails() async {
    // Fetch user details from the repository
    UserDetails? details = await UserDetailsRepository().getUserDetails(
      widget.contactNumber,
    );
    setState(() {
      userDetails = details;
    });
    return userDetails;
  }

  @override
  void initState() {
    getUserDetails();

    // This method is called when the widget is first created.
    super.initState();
  }

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
        key: _scaffoldKey,
        drawer: BNMCDrawer(scaffoldKey: _scaffoldKey, userDetails: userDetails),
        backgroundColor:
            Colors.transparent, // Make scaffold background transparent
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
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
                            'assets/drawable/bhiwandimc.png', // Path to image
                        label: 'About BNCMC',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WebViewScreen(
                                    url:
                                        "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmAboutMsg.aspx",
                                    email: userDetails!.email,
                                    phoneNumber: userDetails!.mobileNo,
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
                            'assets/drawable/bncmclogo.png', // Path to image
                        label: 'Bhiwandi Corporation',
                        onTap: () {
                          Navigator.of(context).push(
                            FadeSlideRoute(
                              page: BhiwandiCorporationScreen(
                                userDetails: userDetails,
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
                    // Card for Mayor Message
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/ic_paybill.png', // Path to image
                        label: 'Bills',
                        onTap: () {
                          // Handle onTap action
                          print('Bills clicked');
                        },
                      ),
                    ),
                    SizedBox(width: 16), // Spacer between cards
                    // Card for Commissioner Message
                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/feedback.png', // Path to image
                        label: 'Complaints',
                        onTap: () {
                          // Handle onTap action
                          print('Complaints clicked');
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
                            'assets/drawable/ic_update.png', // Path to image
                        label: 'Update Profile',
                        onTap: () {},
                      ),
                    ),
                    SizedBox(width: 16), // Spacer between cards

                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/gvt_scheme_image.png', // Path to image
                        label: 'Scheme',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WebViewScreen(
                                    url:
                                        "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmSchemeList.aspx",
                                    email: userDetails!.email,
                                    phoneNumber: userDetails!.mobileNo,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // The only card, aligned to the left
                    Expanded(
                      child: CardItem(
                        imagePath: 'assets/drawable/amrut.png', // Path to image
                        label: 'Amrut Mahotsav',
                        onTap: () {
                          print('Single card clicked');
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

import 'package:bncmc/home/widgets/appbar.dart';
import 'package:bncmc/home/widgets/homecards.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/repository/user_details_repository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String contactNumber;
  const HomeScreen({super.key, required this.contactNumber});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserDetails? userDetails;

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
        backgroundColor:
            Colors.transparent, // Make scaffold background transparent
        appBar: const CustomAppBar(),
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
                          // Handle onTap action
                          print('Mayor Message clicked');
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
                          // Handle onTap action
                          print('Commissioner Message clicked');
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
                        onTap: () {
                          // Handle onTap action
                          print('FAQs clicked');
                        },
                      ),
                    ),
                    SizedBox(width: 16), // Spacer between cards

                    Expanded(
                      child: CardItem(
                        imagePath:
                            'assets/drawable/gvt_scheme_image.png', // Path to image
                        label: 'Scheme',
                        onTap: () {
                          // Handle onTap action
                          print('Notifications clicked');
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

import 'package:bncmc/home/widgets/appbar.dart';
import 'package:bncmc/home/widgets/bncmc_desc.dart';
import 'package:bncmc/home/widgets/drawer.dart';
import 'package:bncmc/home/widgets/homescreen_image.dart';
import 'package:bncmc/home/widgets/new_homecards.dart';
import 'package:bncmc/home/widgets/user_details_strip.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/repository/user_details_repository.dart';
import 'package:flutter/material.dart';

class NewHomescreen extends StatefulWidget {
  final String contactNumber;
  const NewHomescreen({super.key, required this.contactNumber});

  @override
  State<NewHomescreen> createState() => _NewHomescreenState();
}

class _NewHomescreenState extends State<NewHomescreen> {
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
          image: AssetImage('assets/new/background.png'), // Background image
          fit: BoxFit.cover, // Cover the entire screen
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          userDetails: userDetails,
        ),
        drawer: BNMCDrawer(scaffoldKey: _scaffoldKey, userDetails: userDetails),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///
              UserInfoStrip(username: userDetails?.firstName ?? 'Guest'),

              const SizedBox(height: 15),

              ///
              HomeScreenImage(image: "assets/new/Top_banner.png"),

              BncmcDesc(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // prevent inner scrolling
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1.6,
                  children: [
                    NewHomecards(
                      icon: "assets/new/about_us.png",
                      label: 'About BNCMC',
                      onPressed: () => print('Profile tapped'),
                    ),
                    NewHomecards(
                      icon: "assets/new/logo.png",
                      label: 'Bhiwandi Corporation',
                      onPressed: () => print('Settings tapped'),
                      isLogo: true,
                    ),
                    NewHomecards(
                      icon: "assets/new/bill.png",
                      label: 'Bills',
                      onPressed: () => print('Map tapped'),
                    ),
                    NewHomecards(
                      icon: "assets/new/complaints.png",
                      label: 'Complaints',
                      onPressed: () => print('Alerts tapped'),
                    ),
                    NewHomecards(
                      icon: "assets/new/update_profile.png",
                      label: 'Update Profile',
                      onPressed: () => print('Info tapped'),
                    ),
                    NewHomecards(
                      icon: "assets/new/scheme.png",
                      label: 'Scheme',
                      onPressed: () => print('Help tapped'),
                    ),
                  ],
                ),
              ),

              HomeScreenImage(image: "assets/new/bottom_banner.png"),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

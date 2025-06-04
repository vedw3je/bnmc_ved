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
          image: AssetImage('assets/bnmcbackg.jpeg'), // Background image
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

        body: Column(
          children: [
            ///
            UserInfoStrip(username: userDetails?.firstName ?? 'Guest'),

            const SizedBox(height: 10),

            ///
            HomeScreenImage(),

            BncmcDesc(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2, // 2 cards per row
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1.6,
                // adjust for your desired card shape
                children: [
                  NewHomecards(
                    icon: Icons.person,
                    label: 'About BNCMC',
                    onPressed: () => print('Profile tapped'),
                  ),
                  NewHomecards(
                    icon: Icons.settings,
                    label: 'Bhiwandi Corporation',
                    onPressed: () => print('Settings tapped'),
                  ),
                  NewHomecards(
                    icon: Icons.blinds_closed_sharp,
                    label: 'Bills',
                    onPressed: () => print('Map tapped'),
                  ),
                  NewHomecards(
                    icon: Icons.notifications,
                    label: 'Complaints',
                    onPressed: () => print('Alerts tapped'),
                  ),
                  NewHomecards(
                    icon: Icons.info,
                    label: 'Update Profile',
                    onPressed: () => print('Info tapped'),
                  ),
                  NewHomecards(
                    icon: Icons.help,
                    label: 'Scheme',
                    onPressed: () => print('Help tapped'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

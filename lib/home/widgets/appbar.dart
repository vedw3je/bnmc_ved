import 'package:bncmc/customrouteanimation/fade_slide_route.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/update_profile/update_profile_screen.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  UserDetails? userDetails;
  final GlobalKey<ScaffoldState> scaffoldKey;

  CustomAppBar({
    super.key,
    required this.scaffoldKey,
    required this.userDetails,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      centerTitle: true,
      backgroundColor: Colors.deepPurple[700],
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          print("Menu tapped");
          widget.scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 30,
            child: Image.asset(
              'assets/drawable/bncmc_nav_head.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Bhiwandi mSeva',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              FadeSlideRoute(
                page: UpdateProfileScreen(
                  onUserDetailsUpdated: (updatedDetails) {
                    setState(() {
                      widget.userDetails = updatedDetails;
                    });
                    print("Updated details: ${updatedDetails.firstName}");
                  },
                  userDetails: widget.userDetails!,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

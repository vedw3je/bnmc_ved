import 'package:bncmc/customrouteanimation/fade_slide_route.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/update_profile/update_profile_screen.dart';
import 'package:flutter/material.dart';

class AppBarProfile extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  UserDetails? userDetails;

  AppBarProfile({super.key, required this.userDetails})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarProfile> createState() => _AppBarProfileState();
}

class _AppBarProfileState extends State<AppBarProfile> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.deepPurple[700],
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
      centerTitle: true,
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

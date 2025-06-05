import 'package:bncmc/customrouteanimation/fade_slide_route.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/update_profile/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Size get preferredSize => const Size.fromHeight(44);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      toolbarHeight: 36,
      titleSpacing: 5,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 0),
      backgroundColor: Color.fromRGBO(95, 68, 60, 1),
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Logo
          SizedBox(
            height: screenWidth * 0.20,
            width: screenWidth * 0.15,
            child: Image.asset('assets/new/logo.png', fit: BoxFit.contain),
          ),
          const SizedBox(width: 8),

          // Title
          Text(
            'Bhiwandi Corporation',
            style: GoogleFonts.dmSerifDisplay(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              height: 1.0,
              letterSpacing: 0.0,
            ),
          ),

          const Spacer(),

          // Right-side actions grouped in a Row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: () {
                    print("Logout tapped");
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                  ),
                  child: const Text(
                    "LOGOUT",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                ),
                onPressed: () {
                  print("Notifications tapped");
                },
                padding: EdgeInsets.zero, // remove internal IconButton padding
                constraints: const BoxConstraints(), // shrink size
              ),

              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  print("Menu tapped");
                  widget.scaffoldKey.currentState?.openDrawer();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

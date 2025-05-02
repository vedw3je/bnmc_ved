import 'package:flutter/material.dart';

class AppBarStatic extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AppBarStatic({super.key})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.deepPurple[700],
      title: Row(
        mainAxisSize: MainAxisSize.min, // Prevent extra space
        children: [
          SizedBox(
            width: 60,
            height: 30,
            child: Image.asset(
              'assets/drawable/bncmc_nav_head.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8), // Space between image and text
          const Text(
            'Bhiwandi mSeva',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ), // Title in the AppBar
    );
  }
}

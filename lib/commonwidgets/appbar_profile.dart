import 'package:flutter/material.dart';

class AppBarProfile extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AppBarProfile({super.key})
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
            // Add your profile button action here
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Profile'),
                    content: const Text('Profile button tapped.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreenImage extends StatelessWidget {
  const HomeScreenImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        elevation: 6, // Controls shadow depth
        borderRadius: BorderRadius.circular(20),
        shadowColor: Colors.black54,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Rounded corners
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.5, // Show bottom 50%
            widthFactor: 0.95,
            child: Image.asset(
              'assets/drawable/splash_screen.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 240,
            ),
          ),
        ),
      ),
    );
  }
}

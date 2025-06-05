import 'package:flutter/material.dart';

class HomeScreenImage extends StatelessWidget {
  final String image;
  const HomeScreenImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        shadowColor: Colors.black54,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            image,

            fit: BoxFit.cover,
            width: double.infinity,
            height: screenHeight * 0.14, // approx 130px for a 720px screen
          ),
        ),
      ),
    );
  }
}

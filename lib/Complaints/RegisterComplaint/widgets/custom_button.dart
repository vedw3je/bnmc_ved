import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; // The text to be displayed on the button
  final Color color; // The color of the button
  final VoidCallback onPressed; // The callback when the button is pressed

  const CustomButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color, // Dynamic color
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14), // Rounded corners
        ),
        elevation: 5, // Elevated effect
        shadowColor: Colors.black.withOpacity(0.2), // Soft shadow for elevation
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold, // Bold text for better visibility
        ),
      ),
      child: Text(text), // Text of the button
    );
  }
}

import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String imagePath; // Path to the image asset
  final String label;
  final VoidCallback onTap;

  const CardItem({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handling the card click action
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 150, // Width for each card
          height: 170, // Height for each card
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.grey.shade300,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 70, // Adjust the size of the image
                height: 70,
                fit:
                    BoxFit
                        .contain, // Ensures the image fits inside the container
              ),
              SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

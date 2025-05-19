import 'package:flutter/material.dart';

class GradientComplaintContainer extends StatelessWidget {
  final String complaintNumber;

  const GradientComplaintContainer({super.key, required this.complaintNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow[700]!, // Bright Yellow
            Colors.amber[600]!, // Golden
            Colors.brown[700]!, // Dark
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          const Text(
            'Complaint Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            'Complaint No: $complaintNumber',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

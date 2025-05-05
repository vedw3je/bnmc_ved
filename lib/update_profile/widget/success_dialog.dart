import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/greentick.json',
            width: 120,
            height: 120,
            repeat: false,
          ),
          const SizedBox(height: 12),
          const Text(
            'BNCMC',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'User Details Updated Successfully',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

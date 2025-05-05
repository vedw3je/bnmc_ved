import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  TextInputType inputType = TextInputType.text,
  bool isRequired = true, // New parameter to control if the field is required
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        // Only validate if the field is required
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        // Special validation for Aadhaar number (12 digits)
        if (label.toLowerCase().contains('aadhar')) {
          if (value != null && value.length != 12) {
            return 'Aadhaar number must be 12 digits';
          }
        }

        // Email validation
        if (label.toLowerCase().contains('email')) {
          if (value != null &&
              !RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              ).hasMatch(value)) {
            return 'Please enter a valid email address';
          }
        }

        return null;
      },
    ),
  );
}

import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final Future<List<MapEntry<String, String>>> itemsFuture;
  final String? initialSelectedValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator; // ✅ added validator

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.itemsFuture,
    required this.initialSelectedValue,
    required this.onChanged,
    this.validator, // ✅ optional validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder<List<MapEntry<String, String>>>(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final items = snapshot.data ?? [];
            final dropdownItems =
                items
                    .map(
                      (entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList();

            final isValid = items.any((e) => e.key == initialSelectedValue);

            return DropdownButtonFormField<String>(
              value: isValid ? initialSelectedValue : null,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
              ),
              isExpanded: true,
              items: dropdownItems,
              onChanged: onChanged,
              validator: validator, // ✅ pass validator
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatefulWidget {
  final ValueChanged<File>
  onImagePicked; // Callback to send the picked image back to the parent

  const ImagePickerWidget({super.key, required this.onImagePicked});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image; // To store the selected image

  // Method to pick an image from camera or gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();

    // Show dialog for camera or gallery
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose image source"),
          actions: [
            // Option for Camera
            TextButton(
              onPressed: () async {
                final pickedFile = await picker.pickImage(
                  source: ImageSource.camera,
                );

                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                  });
                  widget.onImagePicked(
                    _image!,
                  ); // Notify parent widget with selected image
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Camera"),
            ),
            // Option for Gallery
            TextButton(
              onPressed: () async {
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                  });
                  widget.onImagePicked(
                    _image!,
                  ); // Notify parent widget with selected image
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display the selected image or default icon
        _image != null
            ? Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.file(_image!, fit: BoxFit.cover),
            )
            : Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
            ),
        const SizedBox(height: 10),

        // Button to open the image picker
        ElevatedButton(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green, // Green color for Take Photo
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Take Photo or Select from Gallery',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

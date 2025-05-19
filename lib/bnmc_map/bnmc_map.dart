import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:bncmc/commonwidgets/gradient_container.dart';
import 'package:flutter/material.dart';

class BnmcMapScreen extends StatelessWidget {
  const BnmcMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TransformationController controller = TransformationController();
    return Scaffold(
      appBar: AppBarStatic(), // Using the static AppBar
      body: Column(
        children: [
          // Purple gradient strip with text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GradientContainer(text: 'Corporation Map'),
          ),
          // Zoomable map image
          Expanded(
            child: GestureDetector(
              onDoubleTapDown: (details) {
                final size = MediaQuery.of(context).size;

                // Calculate the scale and offset to center zoom at tap point
                final scaleFactor = 1.5; // Adjust the scale factor as needed
                final dx = details.localPosition.dx / size.width;
                final dy = details.localPosition.dy / size.height;

                // Set the transformation matrix to zoom and center at the double-tap position
                controller.value =
                    Matrix4.identity()
                      ..scale(scaleFactor)
                      ..translate(
                        -dx * (size.width * (scaleFactor - 1)),
                        -dy * (size.height * (scaleFactor - 1)),
                      );
              },
              child: InteractiveViewer(
                panEnabled: true, // Allow pan
                scaleEnabled: true, // Allow zoom
                transformationController: controller,
                child: Image.asset(
                  'assets/drawable/newbhiw.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

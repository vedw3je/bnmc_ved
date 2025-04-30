import 'package:flutter/material.dart';

class KenBurnsSplash extends StatefulWidget {
  final ImageProvider image;
  final Duration duration;
  final ImageProvider logo;

  KenBurnsSplash({
    required this.image,
    required this.logo,
    this.duration = const Duration(seconds: 5),
  });

  @override
  _KenBurnsSplashState createState() => _KenBurnsSplashState();
}

class _KenBurnsSplashState extends State<KenBurnsSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _positionAnimation;

  final double _startScale = 1.4; // Start slightly zoomed in
  final double _endScale = 1.9; // End with more zoom

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _scaleAnimation = Tween<double>(
      begin: _startScale,
      end: _endScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _positionAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0), // Start slightly left
      end: const Offset(0.2, -0.3), // Move slightly right
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _positionAnimation.value.dx * screenSize.width,
                    _positionAnimation.value.dy * screenSize.height,
                  ),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Image(
                      image: widget.image,
                      fit: BoxFit.cover,
                      filterQuality:
                          FilterQuality.high, // Always cover full screen
                    ),
                  ),
                );
              },
            ),
            // BNMC logo at top center
            Positioned(
              top: 50,
              left: (screenSize.width / 2) - 50,
              child: Image(image: widget.logo, width: 150, height: 150),
            ),
          ],
        ),
      ),
    );
  }
}

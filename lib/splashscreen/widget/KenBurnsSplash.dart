import 'package:flutter/material.dart';

class KenBurnsSplash extends StatefulWidget {
  final ImageProvider image;
  final Duration duration;
  final ImageProvider logo;

  const KenBurnsSplash({
    required this.image,
    required this.logo,
    this.duration = const Duration(seconds: 5),
    super.key,
  });

  @override
  _KenBurnsSplashState createState() => _KenBurnsSplashState();
}

class _KenBurnsSplashState extends State<KenBurnsSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _positionAnimation;

  final double _startScale = 1.2;
  final double _endScale = 1.4;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _scaleAnimation = Tween<double>(
      begin: 1.2, // Increased to give buffer for translation
      end: 1.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0.05, 0.0), // Gentle start
      end: const Offset(-0.20, -0.1), // Reduced movement to avoid white edges
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
                    alignment: Alignment.center,
                    child: Image(
                      image: widget.image,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                );
              },
            ),
            // Logo centered at top
            Positioned(
              top: 50,
              left: (screenSize.width / 2) - 75, // Center for 150 width
              child: Image(image: widget.logo, width: 150, height: 150),
            ),
          ],
        ),
      ),
    );
  }
}

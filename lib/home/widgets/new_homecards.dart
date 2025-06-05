import 'package:flutter/material.dart';

class NewHomecards extends StatefulWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;
  final bool? isLogo;

  const NewHomecards({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isLogo,
  });

  @override
  State<NewHomecards> createState() => _NewHomecardsState();
}

class _NewHomecardsState extends State<NewHomecards> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = (screenWidth / 2) - 36;
    final double cardHeight =
        cardWidth * 0.4; // smaller height proportional to width

    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top icon section
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Image.asset(
                    widget.icon,
                    height: 50,
                    color:
                        (widget.isLogo != null && widget.isLogo == true)
                            ? null
                            : Color.fromRGBO(23, 58, 229, 1),
                  ),
                ),
              ),
            ),
            // Bottom label section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(16, 42, 77, 1),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

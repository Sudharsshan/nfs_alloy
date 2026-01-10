import 'package:flutter/material.dart';

class SpotlightPainter extends CustomPainter {
  final Offset cursor;

  SpotlightPainter(this.cursor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Radial gradient for the mask:
    // - Opaque in center (erases blur to reveal sharp background)
    // - Transparent at edges (keeps blur)
    // Use stops and intermediate opacity for softer edges
    paint.shader = RadialGradient(
      colors: [
        Colors.white.withAlpha((1.0*255).ceil()), // Center: full erase
        Colors.white.withAlpha((1.0*255).ceil()), // Hold full erase a bit
        Colors.white.withAlpha((0.0*255).ceil()), // Edge: no erase
      ],
      stops: const [0.0, 0.6, 1.0], // Softer transition starting at 0.6
    ).createShader(
      Rect.fromCircle(center: cursor, radius: 100), // Increased radius for larger, softer reveal
    );

    // Blend mode to "punch a hole" in the blur overlay
    paint.blendMode = BlendMode.dstOut;

    canvas.drawCircle(cursor, 130, paint); // Match radius to shader
  }

  @override
  bool shouldRepaint(covariant SpotlightPainter oldDelegate) {
    return oldDelegate.cursor != cursor;
  }
}
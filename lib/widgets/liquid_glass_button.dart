import 'dart:ui';

import 'package:flutter/material.dart';

/// A reusable Liquid Glass Button widget that mimics the frosted glass effect
/// seen in the provided image (translucent purple-gray with highlight and rounded shape).
///
/// Since your page background is white, the blur effect won't be very noticeable
/// (as blurring white remains white), but the semi-transparent glass overlay
/// with gradient highlight will still give a beautiful glossy appearance.
///
/// You can customize the text, onPressed callback, width, height, etc.
///
/// Usage:
/// LiquidGlassButton(
///   text: 'BUTTON',
///   onPressed: () {
///     // Your action here
///   },
/// )

class LiquidGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final double borderRadius;

  const LiquidGlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 200.0,
    this.height = 60.0,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Color.fromARGB((0.3 * 255).ceil(), 255, 255, 255),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(
                    (0.4 * 255).ceil(),
                    255,
                    255,
                    255,
                  ), // Highlight
                  Color.fromARGB(
                    (0.05 * 255).ceil(),
                    255,
                    255,
                    255,
                  ), // Fade to transparent
                ],
              ),
              color: const Color(0xFF2A2A3A).withAlpha(
                (0.25 * 255).ceil(),
              ), // Dark translucent base (purple-gray tone)
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

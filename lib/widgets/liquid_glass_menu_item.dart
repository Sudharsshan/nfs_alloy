import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LiquidGlassMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const LiquidGlassMenuItem({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Color.fromARGB((0.1 * 255).ceil(), 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.fromARGB((0.3 * 255).ceil(), 255, 255, 255),
                    width: 1.25,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB((0.4 * 255).ceil(), 255, 255, 255),
                      Color.fromARGB(((0.05 * 255).ceil()), 255, 255, 255),
                    ],
                  ),
                  color: const Color(0xFF2A2A3A).withAlpha((0.25 * 255).ceil()),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    FaIcon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

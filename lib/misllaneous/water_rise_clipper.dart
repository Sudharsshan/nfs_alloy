import 'package:flutter/material.dart';

class WaterRiseClipper extends CustomClipper<Path>{

  final double revealPercent;

  WaterRiseClipper({required this.revealPercent});

  @override
  Path getClip(Size size){

    final top = size.height * (1.0 - revealPercent);

    final height = size.height * revealPercent;

    final path = Path();

    path.addRect(
      Rect.fromLTWH(0, top, size.width, height),
    );

    return path;
  }

  @override
  bool shouldReclip(WaterRiseClipper oldClipper){

    return oldClipper.revealPercent != revealPercent;
  }
}
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Credits extends StatelessWidget {
  final double revealTextSize;

  const Credits({super.key, required this.revealTextSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: SizedBox(
        width: 400,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 3,
          children: [
            Text(
              'Designed with ♥ by:',
              style: TextStyle(
                color: ui.Color.fromARGB(255, 153, 153, 153),
                fontSize: revealTextSize * 0.08,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Text(
                'Ryujin Shinko',
                style: TextStyle(
                  color: ui.Color.fromARGB(255, 153, 153, 153),
                  fontSize: revealTextSize * 0.08,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RevealText extends StatefulWidget {
  final String text;
  final double fontSize;
  const RevealText({super.key, required this.fontSize, required this.text});

  @override
  State<RevealText> createState() => RevealTextState();
}

class RevealTextState extends State<RevealText>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  // Animation duration CHANGE IF NEEDED HERE
  Duration animationDuration = const Duration(seconds: 3);
  Duration revealDuration = const Duration(milliseconds: 500);
  Duration pauseDuration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: animationDuration);

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(pauseDuration);
        if (mounted) {
          controller.forward(from: 0.0);
        }
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double opacityForIndex(int index, double focus) {
    final distance = (index - focus).abs();

    if (distance < 1) return 1.0; // fully revealed
    if (distance < 2) return 0.4; // faint
    return 0.0; // hidden
  }

  @override
  Widget build(BuildContext context) {
    final chars = widget.text.split('');

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final focus = controller.value * (chars.length + 2); // sliding window

        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(chars.length, (i) {
              return AnimatedOpacity(
                opacity: opacityForIndex(i, focus),
                duration: revealDuration,
                child: Text(
                  chars[i],
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 160, 160, 160),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

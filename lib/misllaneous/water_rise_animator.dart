// a page to view wallpapers

import 'package:flutter/material.dart';
import 'package:nfs_alloy/misllaneous/water_rise_clipper.dart';

class WaterRiseAnimator extends StatefulWidget{
  final Widget content;
  const WaterRiseAnimator({super.key, required this.content});

  @override
  WaterRiseAnimatorState createState() => WaterRiseAnimatorState();
}


class WaterRiseAnimatorState extends State<WaterRiseAnimator> with TickerProviderStateMixin{

  late AnimationController controller;
  late Animation<double> animation;

  late Widget childWidget = widget.content;

  @override
  void initState() {
    super.initState();

    controller =AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    Future.delayed(const Duration(milliseconds: 100), (){
      if(mounted){
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return AnimatedBuilder(animation: animation, builder: (BuildContext context, Widget? child){

      return ClipPath(
        clipper: WaterRiseClipper(
          revealPercent: animation.value
          ),
        
        child: childWidget,
      );
    });
  }
}
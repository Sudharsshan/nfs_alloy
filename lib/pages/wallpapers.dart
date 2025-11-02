// a page to view wallpapers

import 'package:flutter/material.dart';
import 'package:nfs_alloy/misllaneous/water_rise_animator.dart';

class Wallpapers extends StatefulWidget{
  const Wallpapers({super.key});

  @override
  WallpaperState createState() => WallpaperState();
}


class WallpaperState extends State<Wallpapers>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return WaterRiseAnimator(content: Center(child: Text('Wallpaper page'),));
  }

  Widget pageContent(){

    return Center();
  }
}
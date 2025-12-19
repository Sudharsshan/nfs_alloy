import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfs_alloy/pages/home.dart';
import 'package:nfs_alloy/pages/wallpapers.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final ScrollController scrollController = ScrollController();

  final GlobalKey wallpapersKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // HOME PAGE
        SliverToBoxAdapter(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              scrollController.animateTo(
                MediaQuery.sizeOf(context).height,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              );
            },
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: const Home(),
            ),
          ),
        ),

        // Wallpapers Page
        Wallpapers(),
      ],
    );
  }

  Future<void> lazyScrollDown() async {

    if (!scrollController.hasClients) return;

    final double viewportHeight = MediaQuery.of(context).size.height;

    const double stepFraction = 0.7; // how much of a screen per "drag"
    const Duration stepDuration = Duration(milliseconds: 200);
    const Duration pause = Duration(milliseconds: 90);

    // Scroll about 1.2 screens down (enough to enter Wallpapers)
    final double target = scrollController.offset + viewportHeight * 1.2;

    while (scrollController.offset < target) {
      final nextOffset =
          (scrollController.offset + viewportHeight * stepFraction).clamp(
            0.0,
            scrollController.position.maxScrollExtent,
          );

      await scrollController.animateTo(
        nextOffset,
        duration: stepDuration,
        curve: Curves.linear,
      );

      await Future.delayed(pause);
    }
  }
}

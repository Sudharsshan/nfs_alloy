import 'package:flutter/material.dart';
import 'package:nfs_alloy/pages/wallpapers.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final ScrollController scrollController = ScrollController();

  final GlobalKey wallpapersKey = GlobalKey();

  int fontWidth = 124;
  bool mouseHover = false;

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
              scrollControl();
            },
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: wallpaperButton(),
            ),
          ),
        ),

        // Wallpapers Page
        Wallpapers(scrollController: scrollController,),
      ],
    );
  }

  void scrollControl() {
    scrollController.animateTo(
      MediaQuery.sizeOf(context).height,
      duration: const Duration(milliseconds: 740),
      curve: Curves.easeOut,
    );
  }

  Widget wallpaperButton(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 0, 0, 16),
          child: TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
            ),
            onHover: (bool value) {
              setState(() {
                mouseHover = value;
              });
            },
            onPressed: () {
              scrollControl();
            },
            child: AnimatedDefaultTextStyle(
              style: GoogleFonts.ibmPlexMono(
                color: mouseHover? const Color.fromARGB(255, 83, 83, 83) : const Color.fromARGB(255, 0, 0, 0),
                fontSize: MediaQuery.sizeOf(context).width * fontWidth * 0.001,
              ),
              duration: const Duration(milliseconds: 300),
              child: Text('Wallpapers'),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> lazyScrollDown() async {
    if (!scrollController.hasClients) return;

    final double viewportHeight = MediaQuery.of(context).size.height;

    const double stepFraction = 0.4; // how much of a screen per "drag"
    const Duration stepDuration = Duration(milliseconds: 300);
    const Duration pause = Duration(milliseconds: 110);

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

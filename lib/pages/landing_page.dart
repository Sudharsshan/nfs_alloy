import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfs_alloy/misllaneous/sanity_service.dart';
import 'package:nfs_alloy/misllaneous/spotlight_painter.dart';
import 'package:nfs_alloy/pages/wallpapers.dart';
import 'package:nfs_alloy/widgets/game_selector.dart';

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

  String selectedGame = 'All';

  List<String> activeCategories = ['All'];

  Offset cursorPosition = Offset.zero;

  void loadCategories() async {
    if (kDebugMode) print('Fetching categories');
    List<String> fetched = await SanityService().fetchActiveCategories();
    if (kDebugMode) print('Fetched categories: $fetched');
    if (mounted) {
      setState(() {
        // Keep All at start, append active ones
        activeCategories = ['All', ...fetched];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          cursorPosition = event.localPosition;
        });
      },
      hitTestBehavior: HitTestBehavior
          .translucent, // Allow event to pass through for underlying widgets
      child: Stack(
        children: [
          // Background image
          Positioned.fill(child: Image.asset('lib/assets/bg.png', fit: BoxFit.cover,),),

          // 2. Frosted blur overlay with dynamic clear hole (between background and content)
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.white.withAlpha(
                (0.15 * 255).ceil(),
              ), // Glassmorphic tint
              child: CustomPaint(painter: SpotlightPainter(cursorPosition)),
            ),
          ),

          // Wallpaper content
          CustomScrollView(
            controller: scrollController,
            slivers: [
              // Wallpaper button
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
              Wallpapers(
                key: ValueKey(selectedGame),
                scrollController: scrollController,
                category: selectedGame,
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GameSelector(
                context: context,
                scrollController: scrollController,
                selectedGame: selectedGame,
                activeCategories: activeCategories,
                updateUIfunc: updateUI,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void scrollControl() {
    scrollController.animateTo(
      MediaQuery.sizeOf(context).height,
      duration: const Duration(milliseconds: 740),
      curve: Curves.easeOut,
    );
  }

  Widget wallpaperButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 0, 0, 16),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => mouseHover = true),
            onExit: (_) => setState(() => mouseHover = false),
            child: GestureDetector(
              onTap: () => scrollControl(),
              child: Container(),
              // child: AnimatedDefaultTextStyle(
              //   style: GoogleFonts.tinos(
              //     color: mouseHover
              //         ? const Color.fromARGB(255, 83, 83, 83)
              //         : const Color.fromARGB(255, 0, 0, 0),
              //     fontSize:
              //         MediaQuery.sizeOf(context).width * fontWidth * 0.002,
              //   ),
              //   duration: const Duration(milliseconds: 300),
              //   child: Text('Pictures.'),
              // ),
            ),
          ),
        ),
      ],
    );
  }

  void updateUI(String value) {
    setState(() {
      selectedGame = value;
    });
  }
}

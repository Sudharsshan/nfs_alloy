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
  String? backgroundImageUrl;

  bool isLoading = true;

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

  void loadRandomBackground() async {
    // Call our new sniper method
    String? url = await SanityService().fetchRandomBackgroundImage();

    if (mounted) {
      setState(() {
        backgroundImageUrl = url;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Load all the categories that are available
    loadCategories();

    // load a random background image i.e. fetch it's Url to display as background
    loadRandomBackground();
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
          Positioned.fill(
            child:backgroundBuilder(),
          ),

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

          // Menu buttons to show game names
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

  Widget backgroundBuilder() {
    // If Url is present show that image
    if (backgroundImageUrl != null) {
      return Image.network(
        scale: 0.4,
        backgroundImageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          // while the image is loading show a placeHolder image
          return Image.asset('lib/assets/bg.png', fit: BoxFit.cover);
        },
        errorBuilder: (context, child, stackTrace) {
          // If no internet or cannot laod image, display the same placeHolder image
          return Image.asset('lib/assets/bg.png', fit: BoxFit.cover);
        },
      );
    }

    // If nothing worked, then fall back to local image indicates failure to connect with Sanity.IO
    return Image.asset('lib/assets/bg.png', fit: BoxFit.cover);
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

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfs_alloy/misllaneous/sanity_service.dart';
import 'package:nfs_alloy/misllaneous/spotlight_painter.dart';
import 'package:nfs_alloy/pages/wallpapers.dart';
import 'package:nfs_alloy/widgets/credits.dart';
import 'package:nfs_alloy/widgets/custom_drop_down_menu.dart';
import 'package:nfs_alloy/widgets/game_selector.dart';
import 'package:nfs_alloy/widgets/reveal_text.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> showGames = ValueNotifier(false);

  final GlobalKey wallpapersKey = GlobalKey();

  int fontWidth = 124;
  bool mouseHover = false;

  String selectedGame = 'All';
  String? backgroundImageUrl;

  bool isLoading = true;

  List<String> activeCategories = ['All'];

  Offset cursorPosition = Offset.zero;

  double scrollPosition = 0;

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
    // Obtain physical device width, not using context since it still might be under construction
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final physicalWidth = view.physicalSize.width;

    int targetWidth = physicalWidth.round();
    String? url = await SanityService().fetchRandomBackgroundImage(
      targetWidth: targetWidth,
    );

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

    scrollController.addListener(() {
      final shouldShow = scrollController.position.pixels > 0;

      if (showGames.value != shouldShow) {
        showGames.value = shouldShow;
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double revealTextSize = MediaQuery.sizeOf(context).width * 0.14;
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
          Positioned.fill(child: backgroundBuilder()),

          // 2. Frosted blur overlay with dynamic clear hole (between background and content)
          ValueListenableBuilder(
            valueListenable: showGames,
            builder: (context, visible, child) {
              return AnimatedOpacity(
                opacity: visible ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: child,
              );
            },
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.white.withAlpha(
                  (0.15 * 255).ceil(),
                ), // Glassmorphic tint
                child: CustomPaint(painter: SpotlightPainter(cursorPosition)),
              ),
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
                    child: wallpaperButton(revealTextSize),
                  ),
                ),
              ),

              // Wallpapers Page
              Wallpapers(
                key: ValueKey(selectedGame),
                scrollController: scrollController,
                category: selectedGame,
              ),
              // Bottom credits or extras
              SliverToBoxAdapter(
                child: Credits(revealTextSize: revealTextSize),
              ),
            ],
          ),

          // Menu buttons to show game names
          ValueListenableBuilder(
            valueListenable: showGames,
            builder: (context, visible, child) {
              return AnimatedOpacity(
                opacity: visible ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: child,
              );
            },
            child: Column(
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
          ),

          // Socials button
          Positioned(
            right: 15,
            top: 15,
            child: CustomDropDownMenu(
              childWidget: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.person, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Socials',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w100,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            color: Color.fromARGB(160, 0, 0, 0),
                          ),
                          Shadow(
                            offset: Offset(2, 2),
                            color: Color.fromARGB(120, 255, 255, 255),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

  Widget wallpaperButton(double textSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 0, 0, 16),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: RevealText(text: 'Wallpapers', fontSize: textSize),
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

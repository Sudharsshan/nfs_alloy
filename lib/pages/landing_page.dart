import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfs_alloy/misllaneous/sanity_service.dart';
import 'package:nfs_alloy/pages/wallpapers.dart';
import 'package:google_fonts/google_fonts.dart';
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

        SliverToBoxAdapter(
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

        // Wallpapers Page
        Wallpapers(
          key: ValueKey(selectedGame),
          scrollController: scrollController,
          category: selectedGame,
        ),
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
              child: AnimatedDefaultTextStyle(
                style: GoogleFonts.tinos(
                  color: mouseHover
                      ? const Color.fromARGB(255, 83, 83, 83)
                      : const Color.fromARGB(255, 0, 0, 0),
                  fontSize:
                      MediaQuery.sizeOf(context).width * fontWidth * 0.002,
                ),
                duration: const Duration(milliseconds: 300),
                child: Text('Pictures.'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void updateUI(String value){
    setState(() {
      selectedGame = value;
    });
  }

  // Future<void> lazyScrollDown() async {
  //   if (!scrollController.hasClients) return;

  //   final double viewportHeight = MediaQuery.of(context).size.height;

  //   const double stepFraction = 0.4; // how much of a screen per "drag"
  //   const Duration stepDuration = Duration(milliseconds: 300);
  //   const Duration pause = Duration(milliseconds: 110);

  //   // Scroll about 1.2 screens down (enough to enter Wallpapers)
  //   final double target = scrollController.offset + viewportHeight * 1.2;

  //   while (scrollController.offset < target) {
  //     final nextOffset =
  //         (scrollController.offset + viewportHeight * stepFraction).clamp(
  //           0.0,
  //           scrollController.position.maxScrollExtent,
  //         );

  //     await scrollController.animateTo(
  //       nextOffset,
  //       duration: stepDuration,
  //       curve: Curves.linear,
  //     );

  //     await Future.delayed(pause);
  //   }
  // }
}

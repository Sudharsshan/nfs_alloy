import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfs_alloy/misllaneous/sanity_service.dart';
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

  String selectedGame = 'All';

  List<String> activeCategories = ['All'];

  // Map of Disply Name -> Sanity Value
  final Map<String, String> gameCategories = {
    'All': 'other',
    'NFS 2015': 'nfs-2015',
    'NFS Heat': 'nfs-heat',
    'RDR 2': 'rdr2',
    'Cyberpunk': 'cyberpunk',
    'Elden Ring': 'elden-ring',
    'Forza 4': 'fh4',
    'Forza 5': 'fh5',
    'Torque Drift': 'toqrue-drift',
    'NFS Rivals': 'nfs-rivals',
  };

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

  // make names prettier
  String getPrettyNames(String code) {
    if (code == 'All') return 'All';
    // return dictionary name OR fallBack to capitalizing the code
    return gameCategories[code] ?? code.toUpperCase().replaceAll('-', ' ');
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
            children: [gameSelector()],
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
                style: GoogleFonts.ibmPlexMono(
                  color: mouseHover
                      ? const Color.fromARGB(255, 83, 83, 83)
                      : const Color.fromARGB(255, 0, 0, 0),
                  fontSize:
                      MediaQuery.sizeOf(context).width * fontWidth * 0.001,
                ),
                duration: const Duration(milliseconds: 300),
                child: Text('Wallpapers'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget gameSelector() {
    if (activeCategories.length <= 1) return SizedBox.shrink();

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: activeCategories.length,
        separatorBuilder: (c, i) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          String value = activeCategories[index];
          String name = getPrettyNames(value);
          bool isSelected = selectedGame == value;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedGame = value;
              });

              double galleryStart = MediaQuery.sizeOf(context).height;

              if (scrollController.hasClients) {
                scrollController.animateTo(
                  galleryStart,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              }
            },
            child: Chip(
              label: Text(name),
              backgroundColor: isSelected ? Colors.white : Colors.grey,
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(color: Colors.white24),
            ),
          );
        },
      ),
    );
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

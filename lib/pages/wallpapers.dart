// a page to view wallpapers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfs_alloy/models/wallpaper_loader.dart';
import 'package:nfs_alloy/misllaneous/sanity_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nfs_alloy/widgets/image_pop_up.dart';

class Wallpapers extends StatefulWidget {
  const Wallpapers({super.key});

  @override
  WallpaperState createState() => WallpaperState();
}

class WallpaperState extends State<Wallpapers>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Future<List<Wallpaperloader>> wallpaperLoader;

  bool isEnabled = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.forward();
    });

    // load the images once
    wallpaperLoader = SanityService().fetchGalleryImages();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return pageContent();
  }

  Widget pageContent() {
    return FutureBuilder(
      future: wallpaperLoader,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        List<Wallpaperloader> images = snapshot.data!;
        if (kDebugMode) {
          print('No. of images fetched: ${images.length}');
        }

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          sliver: SliverMasonryGrid.count(
            // main & cross axis spacing
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            crossAxisCount: (MediaQuery.sizeOf(context).width < 1200) ? 3 : 4,

            // display images
            childCount: images.length,
            itemBuilder: (context, index) {
              Wallpaperloader img = images[index];

              // handle on tap to load a pop-up of full image
              final String heroTag = img.imageUrl;

              return FadeTransition(
                opacity: controller,
                child: SlideTransition(
                  position: controller.drive(
                    Tween(begin: const Offset(0, 0.15), end: Offset.zero),
                  ),
                  child: imgTileWithGesture(img, heroTag),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget imgTileWithGesture(Wallpaperloader img, String heroTag) {
    return GestureDetector(
      onTap: () {
        ImagePopUp(context: context, img: img, heroTag: heroTag).imagePopUp();
      },
      child: Hero(tag: heroTag, child: imageBox(img)),
    );
  }

  Widget imageBox(Wallpaperloader img) {
    // a scale down version of the full image url
    final int w = 600, q = 90;
    final String thumbnailUrl = '${img.imageUrl}?w=$w&q=$q&fm=webp';

    // url to load full resolution image
    //final String fullResUrl = img.imageUrl;

    return CachedNetworkImage(
      memCacheWidth: w,
      fit: BoxFit.fitWidth,
      imageUrl: thumbnailUrl,
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      placeholder: (context, url) =>
          Center(child: CircularProgressIndicator.adaptive(strokeWidth: 2.0)),
    );
  }
}

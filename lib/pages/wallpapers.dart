// a page to view wallpapers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:nfs_alloy/misllaneous/water_rise_animator.dart';
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

class WallpaperState extends State<Wallpapers> {
  late Future<List<Wallpaperloader>> wallpaperLoader;

  bool isEnabled = true;

  @override
  void initState() {
    super.initState();

    // load the images once
    wallpaperLoader = SanityService().fetchGalleryImages();
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
          return Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No images found.'));
        }

        List<Wallpaperloader> images = snapshot.data!;
        if (kDebugMode) {
          print('No. of images fetched: ${images.length}');
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: CustomScrollView(
            slivers: [
              // Wallpaper text
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Wallpapers',
                    style: GoogleFonts.alata(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),

              // Wallpaper images with lazy loading
              SliverMasonryGrid.count(
                // main & cross axis spacing
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                crossAxisCount: (MediaQuery.sizeOf(context).width < 1200)
                    ? 3
                    : 4,

                // display images
                itemBuilder: (context, index) {
                  Wallpaperloader img = images[index];

                  // handle on tap to load a pop-up of full image
                  final String heroTag = img.imageUrl;

                  return GestureDetector(
                    onTap: () {
                      ImagePopUp(context: context,img:  img,heroTag:  heroTag).imagePopUp();
                    },
                    child: Hero(tag: heroTag, child: imageBox(img)),
                  );
                },
                // No. of imagse
                childCount: images.length,
              ),
            ],
          ),
        );
      },
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

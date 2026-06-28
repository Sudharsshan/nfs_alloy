import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nfs_alloy/misllaneous/image_downloader.dart';
import 'package:nfs_alloy/models/game_categories.dart';
import 'package:nfs_alloy/models/wallpaper_loader.dart';

class ImagePopUp {
  final BuildContext context;
  final Wallpaperloader img;
  final String heroTag;

  ImagePopUp({required this.context, required this.img, required this.heroTag});

  final Map<String, String> gameNames = GameCategories().gameNames;

  void imagePopUp() {
    final String imgUrl = img.imageUrl;
    final String name = img.title;
    final String description = img.description;
    final String gameName = gameNames[img.gameCategory]!;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      transitionDuration: const Duration(milliseconds: 300),

      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  // Image pop-up
                  Hero(
                    tag: heroTag, // The *same* tag from the grid
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: CachedNetworkImage(
                          // We use the FULL-RESOLUTION URL here
                          imageUrl: imgUrl,
                          width: MediaQuery.widthOf(context) * 0.6,

                          // Show a spinner while the *full-res* image downloads
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),

                  // Name and description of the image
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Game name
                        Text(
                          gameName,
                          //overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        // Img ame
                        Text(
                          name,
                          //overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 27,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),

                        // Description
                        Text(
                          description,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w200,
                            color: Colors.grey,
                            decoration: TextDecoration.none,
                          ),
                        ),

                        // some spacing
                        const SizedBox(height: 45),

                        // download button
                        GestureDetector(
                          onTap: () {
                            final rawUrl = getRawSanityUrl(imgUrl);
                            Imagedownloader().downloadImage(rawUrl, name);
                          },
                          child: Container(
                            width: 120,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(150, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.download,
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  size: 20,
                                ),

                                SizedBox(width: 8),

                                Text(
                                  'Download',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String getRawSanityUrl(String url) {
    // Split by ? to remove all processing params
    final Uri uri = Uri.parse(url);

    // reconstruct url without base query params
    String rawUrl = '${uri.scheme}://${uri.host}${uri.path}';

    // force Sanity to treat this as a download
    return '$rawUrl?dl=';
  }
}

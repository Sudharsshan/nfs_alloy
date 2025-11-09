import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfs_alloy/misllaneous/image_downloader.dart';
import 'package:nfs_alloy/models/wallpaper_loader.dart';

class ImagePopUp {
  final BuildContext context;
  final Wallpaperloader img;
  final String heroTag;

  ImagePopUp({required this.context, required this.img, required this.heroTag});

  void imagePopUp() {
    final String imgUrl = img.imageUrl;
    final String name = img.title;
    final String description = img.description;
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Name
                      Text(
                        name,
                        style: GoogleFonts.alata(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),

                      // Description
                      Text(
                        description,
                        style: GoogleFonts.aladin(
                          fontSize: 30,
                          fontWeight: FontWeight.w200,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),

                      // some spacing
                      const SizedBox(height: 20),

                      // download button
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(150, 255, 255, 255),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton.icon(
                          icon: Icon(Icons.download, color: Colors.white),
                          onPressed: () {
                            Imagedownloader().downloadImage(imgUrl, name);
                          },
                          label: Text(
                            'DOWNLOAD',
                            style: GoogleFonts.aladin(
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

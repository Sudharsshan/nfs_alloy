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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 45),

                      // download button
                      GestureDetector(
                        onTap: (){
                          Imagedownloader().downloadImage(imgUrl, name);
                        },
                        child: Container(
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
                                color: const Color.fromARGB(255, 255, 255, 255),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

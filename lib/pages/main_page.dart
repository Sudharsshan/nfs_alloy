// the main-page which just holds an empty wallpaper and the functions to load the other screens

import 'package:flutter/material.dart';
import 'package:nfs_alloy/pages/about.dart';
import 'package:nfs_alloy/pages/empty.dart';
import 'package:nfs_alloy/pages/wallpapers.dart';

class MainPage extends StatelessWidget {
  PageController pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 218, 218),
      body: Stack(
        children: [
          // wallpaper
          Image(
            image: AssetImage('lib/assets/nissinneon.png'),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            fit: BoxFit.fill,
          ),

          // page view for different pages
          PageView(
            controller: pageController,
            children: [
              // first page = home page  = empty page
              Empty(),

              // wallpaper page
              Wallpapers(),

              // about me page
              About(),
            ],
          ),

          // row of pages in bottom left
          Positioned(
            left: MediaQuery.sizeOf(context).width * 0.5 - 300 ,
            bottom: MediaQuery.sizeOf(context).height * 0.04,
            child: Stack(
              alignment: AlignmentGeometry.center,
              children: [
                // background stroke
                Image(
                  image: AssetImage('lib/assets/brushstroke.png'),
                  width: 600,
                  height: 100,
                ),

                // menu
                Row(
                  children: [
                    // home page button
                    TextButton(
                      onPressed: () {
                        pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear,
                        );
                      },
                      child: Text('HOME'),
                    ),

                    // wallpaper page button
                    TextButton(
                      onPressed: () {
                        pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear,
                        );
                      },
                      child: Text('WALLPAPERs'),
                    ),

                    // about page button
                    TextButton(
                      onPressed: () {
                        pageController.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear,
                        );
                      },
                      child: Text('ABOUT'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

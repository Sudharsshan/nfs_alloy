// the main-page which just holds an empty wallpaper and the functions to load the other screens

import 'package:flutter/material.dart';
import 'package:nfs_alloy/pages/about.dart';
import 'package:nfs_alloy/pages/empty.dart';
import 'package:nfs_alloy/pages/wallpapers.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  PageController pageController = new PageController();
  bool hoverbtn1 = false, hoverbtn2 = false, hoverbtn3 = false;

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
            left: MediaQuery.sizeOf(context).width * 0.5 - 300,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // home page button
                    menuButton(0, 'HOME', hoverbtn1, 0),

                    // wallpaper page button
                    menuButton(1, 'WALLPAPERS', hoverbtn2, 1),

                    // about page button
                    menuButton(2, 'ABOUT', hoverbtn3, 2),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuButton(int page, String option, bool buttonID, int whichButton) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 0),
      child: TextButton(
        onPressed: () {
          pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          );
        },
        onHover: (bool value) {
          setState(() {
            buttonID = value;
            dumbBoolChanger(value, whichButton);
          });
          print("$option, value = $buttonID");
        },
        style: ButtonStyle(
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
        ),
        child: AnimatedDefaultTextStyle(
          style: TextStyle(color: buttonID ? Colors.blue : Colors.black),
          duration: const Duration(milliseconds: 300),
          child: Text(option, style: TextStyle(fontStyle: FontStyle.italic),),
        ),
      ),
    );
  }

  void dumbBoolChanger(bool value, int button){
    switch(button){
      case 0: hoverbtn1 = value;
      case 1: hoverbtn2 = value;
      case 2: hoverbtn3 = value;
    }
  }
}

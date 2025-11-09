// the main-page which just holds an empty wallpaper and the functions to load the other screens

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfs_alloy/pages/about.dart';
//import 'package:nfs_alloy/pages/empty.dart';
import 'package:nfs_alloy/pages/wallpapers.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  PageController pageController = PageController();
  bool hoverbtn1 = false,
      hoverbtn2 = false,
      hoverbtn3 = false,
      activeBtn = false;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 247),
        elevation: 0.0,
        actions: [
          // home page button
          //menuButton(0, 'HOME', hoverbtn1, 0),

          // wallpaper page button
          menuButton(0, 'WALLPAPERS', hoverbtn2, 0),

          // about page button
          menuButton(1, 'ABOUT', hoverbtn3, 1),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 245, 245, 247),
      body: PageView(
        controller: pageController,
        children: [Wallpapers(), About()],
      ),
    );
  }

  Widget menuButton(int page, String option, bool buttonID, int whichButton) {
    Color buttonColor = buttonID
        ? const Color.fromARGB(255, 33, 82, 243)
        : ((page == currentPage)
              ? const Color.fromARGB(255, 255, 0, 0)
              : const Color.fromARGB(255, 0, 0, 0));
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 0),
      child: TextButton(
        onPressed: () {
          currentPage = page;
          pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        },
        onHover: (bool value) {
          setState(() {
            buttonID = value;
            dumbBoolChanger(value, whichButton);
          });
          if (kDebugMode) {
            print("$option, value = $buttonID");
          }
        },
        style: ButtonStyle(
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
        ),
        child: AnimatedDefaultTextStyle(
          style: TextStyle(color: buttonColor),
          duration: const Duration(milliseconds: 300),
          child: Text(option),
        ),
      ),
    );
  }

  void dumbBoolChanger(bool value, int button) {
    switch (button) {
      // case 0:
      //   hoverbtn1 = value;
      case 0:
        hoverbtn2 = value;
      case 1:
        hoverbtn3 = value;
    }
  }
}

// the main-page which just holds an empty wallpaper and the functions to load the other screens

import 'package:flutter/material.dart';
import 'package:nfs_alloy/widgets/liquid_glass_button.dart';
import 'package:nfs_alloy/pages/landing_page.dart';
import 'package:nfs_alloy/widgets/custom_drop_down_menu.dart';
//import 'package:nfs_alloy/pages/empty.dart';

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
    //pageController.jumpToPage(currentPage);
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFFE0E0E0),
      //   elevation: 0.0,
      //   // leading: menuButton(999, 'ChrXme.png', true, 999),
      //   // leadingWidth: 180,
      //   actions: [
      //     // home page button
      //     //menuButton(0, 'HOME', hoverbtn1, 0),

      //     // wallpaper page button
      //     menuButton(0, 'WALLPAPERS', hoverbtn2, 1),

      //     // about page button
      //     menuButton(1, 'ABOUT', hoverbtn3, 2),

      //     // spacer to push them middle
      //     SizedBox(width: MediaQuery.sizeOf(context).width / 2 - 182),
      //   ],
      // ),
      // backgroundColor: const Color.fromARGB(255, 245, 245, 247),
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            hitTestBehavior: HitTestBehavior.translucent,
            children: [LandingPage(),],
            // onPageChanged: (value) {
            //   setState(() {
            //     switch (value) {
            //       case 0:
            //         dumbBoolChanger(true, 0);
            //         dumbBoolChanger(false, 1);
            //       case 1:
            //         dumbBoolChanger(true, 1);
            //         dumbBoolChanger(false, 0);
            //     }
            //   });
            // },
          ),

          Positioned(
            right: 15,
            top: 15,
            child: CustomDropDownMenu(
              childWidget: LiquidGlassButton(text: 'About'),
            ),
          ),
        ],
      ),
    );
  }

  // Widget menuButton(int page, String option, bool buttonID, int whichButton) {
  //   Color buttonColor = ((page == currentPage)
  //             ? const Color.fromARGB(255, 0, 0, 0)
  //             : const Color(0xFFE0E0E0));
  //   return Padding(
  //     padding: EdgeInsetsGeometry.symmetric(horizontal: 0, vertical: 8),
  //     child: TextButton(
  //       onPressed: () {
  //         if (page != 999) {
  //           currentPage = page;
  //           pageController.animateToPage(
  //             page,
  //             duration: const Duration(milliseconds: 250),
  //             curve: Curves.linear,
  //           );
  //         }
  //       },
  //       // onHover: (bool value) {
  //       //   setState(() {
  //       //     buttonID = value;
  //       //     dumbBoolChanger(value, whichButton);
  //       //   });
  //       //   if (kDebugMode) {
  //       //     print("$option, value = $buttonID");
  //       //   }
  //       // },
  //       style: ButtonStyle(
  //         overlayColor: WidgetStatePropertyAll(Colors.transparent),
  //         splashFactory: NoSplash.splashFactory,
  //       ),
  //       child: AnimatedDefaultTextStyle(
  //         style: GoogleFonts.lato(
  //           fontSize: 34,
  //           color: buttonColor,
  //           // fontStyle: FontStyle.italic,
  //           fontWeight: FontWeight.bold,
  //         ),
  //         duration: const Duration(milliseconds: 300),
  //         child: embossText(option),
  //       ),
  //     ),
  //   );
  // }

  // Widget embossText(String text) {
  //   return Text(
  //     text,
  //     style: TextStyle(
  //       // fontSize: 35,
  //       // fontWeight: FontWeight.bold,
  //       // color: const Color(0xFFE0E0E0), // same as background
  //       shadows: [
  //         // highlight (top-left)
  //         Shadow(offset: Offset(-2, -2), blurRadius: 3, color: Colors.white),
  //         // shadow (bottom-right)
  //         Shadow(offset: Offset(2, 2), blurRadius: 3, color: Colors.black26),
  //       ],
  //     ),
  //   );
  // }

  // void dumbBoolChanger(bool value, int button) {
  //   switch (button) {
  //     // case 0:
  //     //   hoverbtn1 = value;
  //     case 0:
  //       hoverbtn1 = value;
  //     case 1:
  //       hoverbtn2 = value;
  //     case 2:
  //       hoverbtn3 = value;
  //   }
  // }
}

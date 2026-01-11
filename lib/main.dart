import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfs_alloy/pages/landing_page.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PageView(
          controller: pageController,
          hitTestBehavior: HitTestBehavior.translucent,
          children: [LandingPage()],
        ),
      ),
    );
  }
}

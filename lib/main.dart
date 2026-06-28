import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfs_alloy/pages/landing_page.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: LandingPage()),
    );
  }
}

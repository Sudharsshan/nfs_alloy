// the main-page which just holds an empty wallpaper and the functions to load the other screens

import 'package:flutter/material.dart';

class MainPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 218, 218),
      body: Center(
        child: Text('Main page'),
      ),
    );
  }
}
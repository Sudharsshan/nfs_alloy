// Dispaly a wheel .gif with a text below stating min resolution.

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// neeed this for timer function
import 'dart:async';

import 'package:nfs_alloy/pages/main_page.dart';

class Loading extends StatefulWidget{
  const Loading({super.key});

  @override
  LoadingState createState() => LoadingState(); 

}

class LoadingState extends State<Loading>{
  late final Future<LottieComposition> _composition;
  
  // text sizes
  double load = 80, advice = 22;
  
  // text styles
  late TextStyle loadstyle = TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: load, fontStyle: FontStyle.italic);
  late TextStyle adviceStyle = TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: advice, fontStyle: FontStyle.italic);
  

  @override
  void initState() {
    super.initState();

    // load the asset from library
    _composition = AssetLottie('lib/assets/tyre.json').load();

    // start a timer
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer(){
    // a custom timer function to wait for 3 seconds and push the screen from this loading to main_page

    Timer(Duration(seconds: 3), (){
      // push the screen into the new page
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => MainPage()
        )
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 218, 218),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // loading TXT
            Text("Loading...", style: loadstyle,),

            // Lottie anim
            SizedBox(
              width: 900,
              height: 100,
              child: wheelAnim(),
            ),

            // suggestion
            Text('to obtain best experience, please maintain a minimum reolution of 1600x900...', style: adviceStyle,),
          ],
        ),
      ),
    );
  }

  Widget wheelAnim(){
    // A custom widget to load the lottie animation
    return FutureBuilder<LottieComposition>(
      future: _composition,
      builder: (context, snapshot) {
        var composition = snapshot.data;
        if (composition != null) {
          return Lottie(
            composition: composition,
            repeat: false,
            );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
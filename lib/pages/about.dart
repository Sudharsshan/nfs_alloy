// a page about him...

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfs_alloy/misllaneous/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          // a nice photo to show RIPJVW
          Center(
            child: SizedBox(
              width: 400,
              height: 400,
              child: Container(color: Colors.grey),
            ),
          ),

          // some spacing
          const SizedBox(width: 20,),

          // a list of texts
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Label
              Text(
                'RIPJVW',
                style: GoogleFonts.abel(color: Color.fromARGB(255, 0, 0, 0)),
              ),

              // Description
              // Text('')

              // Social Link
              Row(
                children: [
                  // Instagram
                  IconButton.filled(
                    onPressed: () {
                      // navigate to that website
                      UrlLauncher(context: context, url: 'https://www.instagram.com/').launchUrl();
                    },
                    icon: Icon(
                      Icons.square_rounded,
                      color: Color.fromARGB(255, 238, 78, 198),
                    ),
                  ),

                  // other buttons
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

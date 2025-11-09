// a page about him...

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfs_alloy/misllaneous/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});
  final String instagramLink = "https://www.instagram.com/";

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
          const SizedBox(width: 20),

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
                  linkLauncher(Icon(Icons.social_distance), instagramLink, context),

                  // some spacing
                  const SizedBox(width: 10,),
                  // other buttons
                  linkLauncher(Icon(Icons.bolt), 'https://google.com', context),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget linkLauncher(Icon icon, String launchUrl, BuildContext context) {
    return IconButton.filled(
      onPressed: () {
        // navigate to that website
        UrlLauncher(context: context, url: launchUrl).launchUrl();
      },
      icon: Icon(
        Icons.square_rounded,
        color: Color.fromARGB(255, 238, 78, 198),
      ),
    );
  }
}

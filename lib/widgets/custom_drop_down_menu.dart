import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nfs_alloy/misllaneous/url_launcher.dart';

class CustomDropDownMenu extends StatelessWidget {
  final Widget childWidget;
  const CustomDropDownMenu({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: null,
      onSelected: (value) => {
        if (value == 1)
          {
            // Launch INSTAGRAM page
            if (kDebugMode) debugPrint('Launching Instagram page.'),
            UrlLauncher(
              url: 'https://www.instagram.com/ripjvw/',
              context: context,
            ).launchUrl(),
          }
        else if (value == 2)
          {
            // Launch YOUTUBE page
            if (kDebugMode) debugPrint('Launching Youtube page.'),
            UrlLauncher(
              url: 'https://youtube.com/@ripjvw',
              context: context,
            ).launchUrl(),
          },
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          height: 35,
          padding: EdgeInsets.zero,
          child: menuItem('Instagram', FontAwesomeIcons.instagram),
        ),

        PopupMenuItem(
          value: 2,
          height: 35,
          padding: EdgeInsets.zero,
          child: menuItem('Youtube', FontAwesomeIcons.youtube),
        ),
      ],
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeOutCubic,
        duration: const Duration(milliseconds: 450),
      ),
      offset: Offset(-15, 38),
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      child: childWidget,
    );
  }

  Widget menuItem(String content, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 8),
        Text(
          content,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w100,
            shadows: [
              Shadow(offset: Offset(1, 1), color: Color.fromARGB(160, 0, 0, 0)),
              Shadow(
                offset: Offset(2, 2),
                color: Color.fromARGB(120, 255, 255, 255),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

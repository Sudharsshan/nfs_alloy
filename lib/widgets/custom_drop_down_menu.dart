import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nfs_alloy/misllaneous/url_launcher.dart';
import 'package:nfs_alloy/widgets/liquid_glass_menu_item.dart';

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
              url: 'https://www.instagram.com/chrxme.png/',
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
          height: 58,
          padding: EdgeInsets.zero,
          child: LiquidGlassMenuItem(
            title: 'Instagram',
            icon: FontAwesomeIcons.instagram,
          ),
        ),

        PopupMenuItem(
          value: 2,
          height: 58,
          padding: EdgeInsets.zero,
          child: LiquidGlassMenuItem(
            title: 'Youtube',
            icon: FontAwesomeIcons.youtube,
          ),
        ),
      ],
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeInCirc,
        duration: const Duration(milliseconds: 200),
      ),
      offset: Offset(-15, 60),
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: childWidget,
    );
  }

  Widget menuChild(String id, Icon menuIcon) {
    return Row(
      children: [
        // menu option icon
        Icon(menuIcon.icon),

        // some space
        const SizedBox(width: 10),

        // Menu option text
        Text(id),
      ],
    );
  }
}

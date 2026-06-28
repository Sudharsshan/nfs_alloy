import 'package:flutter/material.dart';
import 'package:nfs_alloy/widgets/custom_drop_down_menu.dart';
import 'package:nfs_alloy/widgets/game_selector.dart';

class CustomAppBar extends StatelessWidget {
  final ValueNotifier<bool> showGames;
  final ScrollController scrollController;
  final String selectedGame;
  final List<String> activeCategories;
  final Function updateUI;
  const CustomAppBar({
    super.key,
    required this.showGames,
    required this.activeCategories,
    required this.scrollController,
    required this.selectedGame,
    required this.updateUI,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Menu buttons to show game names
        ValueListenableBuilder(
          valueListenable: showGames,
          builder: (context, visible, child) {
            return AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: child,
            );
          },
          child: GameSelector(
            context: context,
            scrollController: scrollController,
            selectedGame: selectedGame,
            activeCategories: activeCategories,
            updateUIfunc: updateUI,
          ),
        ),

        // Socials button
        CustomDropDownMenu(
            childWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.person, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Socials',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w100,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          color: Color.fromARGB(160, 0, 0, 0),
                        ),
                        Shadow(
                          offset: Offset(2, 2),
                          color: Color.fromARGB(120, 255, 255, 255),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

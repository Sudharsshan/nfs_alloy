import 'package:flutter/material.dart';
import 'package:nfs_alloy/models/game_categories.dart';
import 'package:nfs_alloy/widgets/liquid_glass_button.dart';

class GameSelector extends StatefulWidget {
  final List<String> activeCategories;
  final String selectedGame;
  final ScrollController scrollController;
  final BuildContext context;
  final Function updateUIfunc;

  const GameSelector({
    super.key,
    required this.context,
    required this.activeCategories,
    required this.selectedGame,
    required this.scrollController,
    required this.updateUIfunc,
  });

  @override
  State<GameSelector> createState() => GameSelectorState();
}

class GameSelectorState extends State<GameSelector> {
  // Map of Disply Name -> Sanity Value
  final Map<String, String> gameCategories = GameCategories().gameCategories;

  @override
  Widget build(BuildContext context) {
    return gameSelector();
  }

  // make names prettier
  String getPrettyNames(String code) {
    if (code == 'All') return 'All';
    // return dictionary name OR fallBack to capitalizing the code
    return gameCategories[code] ?? code.toUpperCase().replaceAll('-', ' ');
  }

  Widget gameSelector() {
    String selectedGame = widget.selectedGame;
    ScrollController scrollController = widget.scrollController;
    if (widget.activeCategories.length <= 1) return SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.activeCategories.length,
        separatorBuilder: (c, i) => SizedBox(width: 15),
        itemBuilder: (context, index) {
          String value = widget.activeCategories[index];
          String name = getPrettyNames(value);
          bool isSelected = selectedGame == value;

          return GestureDetector(
            onTap: () {
              widget.updateUIfunc(value);

              double galleryStart = MediaQuery.sizeOf(context).height;

              if (scrollController.hasClients) {
                scrollController.animateTo(
                  galleryStart,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );

                scrollController.animateTo(
                  MediaQuery.sizeOf(context).height,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: gameIDChips(isSelected, name),
            ),
          );
        },
      ),
    );
  }

  Widget gameIDChips(bool activeButton, String gameName) {
    return LiquidGlassButton(
      text: gameName,
      textColor: activeButton ? Colors.black : Colors.white,
      isActive: activeButton,
    );
  }
}

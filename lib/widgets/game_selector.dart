import 'package:flutter/material.dart';
import 'package:nfs_alloy/models/game_categories.dart';

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
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Center(child: gameIDChips(isSelected, name),),
            ),
          );
        },
      ),
    );
  }

  Widget gameIDChips(bool activeButton, String gameName) {
    return Text(
      gameName,
      style: TextStyle(
        fontWeight: activeButton ? FontWeight.bold : FontWeight.w100,
        fontSize: activeButton? 32 : 22,
        shadows: [
          Shadow(offset: Offset(1, 1), color: Color.fromARGB(160, 0, 0, 0)),
          Shadow(
            offset: Offset(2, 2),
            color: Color.fromARGB(120, 255, 255, 255),
          ),
        ],
        color: Colors.white,
      ),
    );
  }
}

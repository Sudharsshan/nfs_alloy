import 'package:flutter/material.dart';

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
  final Map<String, String> gameCategories = {
    'All': 'other',
    'NFS 2015': 'nfs-2015',
    'NFS Heat': 'nfs-heat',
    'RDR 2': 'rdr2',
    'Cyberpunk': 'cyberpunk',
    'Elden Ring': 'elden-ring',
    'Forza 4': 'fh4',
    'Forza 5': 'fh5',
    'Torque Drift': 'toqrue-drift',
    'NFS Rivals': 'nfs-rivals',
  };

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
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.activeCategories.length,
        separatorBuilder: (c, i) => SizedBox(width: 12),
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
            child: Chip(
              label: Text(name),
              backgroundColor: isSelected ? Colors.white : Colors.grey,
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(color: Colors.white24),
            ),
          );
        },
      ),
    );
  }
}

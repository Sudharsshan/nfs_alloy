// a page to view wallpapers

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nfs_alloy/models/tile_span.dart';
import 'package:nfs_alloy/misllaneous/tile_weights.dart';
import 'package:nfs_alloy/models/wallpaper_loader.dart';
import 'package:nfs_alloy/misllaneous/sanity_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nfs_alloy/widgets/image_pop_up.dart';

class Wallpapers extends StatefulWidget {
  // Accept scroll controller from the parent
  final ScrollController scrollController;
  final String category;

  const Wallpapers({
    super.key,
    required this.scrollController,
    required this.category,
  });

  @override
  WallpaperState createState() => WallpaperState();
}

class WallpaperState extends State<Wallpapers>
    with SingleTickerProviderStateMixin {
  // late AnimationController controller;

  // 2. State variables for data
  final List<Wallpaperloader> _wallpapers = [];
  bool _isLoading = false;
  bool _hasMore = true; // Stop trying if we ran out of images
  int _currentCount = 0;
  final int _chunkSize = 15; // How many to load at a time

  late final List<QuiltedGridTile> quiltPattern;

  final editorialBlocks = [
    // Hero left
    [TileSpan(3, 2), TileSpan(1, 1), TileSpan(1, 1)],

    // Hero right
    [TileSpan(1, 1), TileSpan(1, 1), TileSpan(3, 2)],

    // Mosaic
    [TileSpan(2, 2), TileSpan(1, 1), TileSpan(1, 1)],
  ];

  final quiltPattern3 = [
    // Row 1
    QuiltedGridTile(2, 2),
    QuiltedGridTile(1, 1),

    // Row 2 continuation
    QuiltedGridTile(1, 1),
  ];

  final quiltPattern4 = const [QuiltedGridTile(2, 3), QuiltedGridTile(2, 1)];

  @override
  void initState() {
    super.initState();

    fetchMoreImages();

    quiltPattern = generatePattern(20);

    // listen to parent scroll behaviour
    widget.scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(onScroll);
    // controller.dispose();
    super.dispose();
  }

  void onScroll() {
    // detect bottom of scroll position
    if (_isLoading || !_hasMore) return;

    // trigger if less than 200px from bottom
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      fetchMoreImages();
    }
  }

  Future<void> fetchMoreImages() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Calculate indices: 0..14, 15..29,etc
      final newImages = await SanityService().fetchGalleryImages(
        start: _currentCount,
        end: _currentCount + _chunkSize - 1,
        category: widget.category,
      );

      if (mounted) {
        setState(() {
          if (newImages.isEmpty) {
            _hasMore = false; // Loaded all images
          } else {
            _wallpapers.addAll(newImages);
            _currentCount += newImages.length;

            // if response img count is less than requested, reached end
            if (newImages.length < _chunkSize) _hasMore = false;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) print("Fetch error: $e");
      setState(() {
        _isLoading = false;
      });
    }

    // load tile sizes
    generateTileSizes(_currentCount);
  }

  double heightMultiplier(TileSize size) {
    switch (size) {
      case TileSize.large:
        return 1.8;
      case TileSize.medium:
        return 1.3;
      case TileSize.small:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = (MediaQuery.sizeOf(context).width < 1200) ? 3 : 4;
    return SliverMainAxisGroup(
      slivers: [
        // The images grid
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          sliver: AnimationLimiter(child: quiltedGridTiles(columnCount)),
        ),

        // The loading icon spinner
        SliverToBoxAdapter(
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(22),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget quiltedGridTiles(int columnCount) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        final img = _wallpapers[index];
        final heroTag = '${img.imageUrl}_$index';
        return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 500),
          columnCount: columnCount,
          child: ScaleAnimation(
            child: FadeInAnimation(child: imgTileWithGesture(img, heroTag)),
          ),
        );
      }, childCount: _wallpapers.length),
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: columnCount,
        pattern: getQuiltPattern(columnCount),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
      ),
    );
  }

  List<QuiltedGridTile> generatePattern(int blocks) {
    final rand = Random(42);
    final pattern = <QuiltedGridTile>[];

    for (int i = 0; i < blocks; i++) {
      final block = editorialBlocks[rand.nextInt(editorialBlocks.length)];
      for (final tile in block) {
        pattern.add(QuiltedGridTile(tile.row, tile.col));
      }
    }
    return pattern;
  }

  List<QuiltedGridTile> getQuiltPattern(int columnCount) {
    if (columnCount == 3) return quiltPattern3;
    return quiltPattern4;
  }

  Widget tiles() {
    return SliverMasonryGrid.count(
      // main & cross axis spacing
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      crossAxisCount: (MediaQuery.sizeOf(context).width < 1200) ? 3 : 4,

      // display images
      childCount: _wallpapers.length,
      itemBuilder: (context, index) {
        Wallpaperloader img = _wallpapers[index];

        // handle on tap to load a pop-up of full image
        final String heroTag = '${img.imageUrl}_$index';

        final screenWidth = MediaQuery.sizeOf(context).width;
        final columnCount = screenWidth < 1200 ? 3 : 4;
        final columnWidth = (screenWidth - (columnCount - 1) * 4) / columnCount;

        final size = tileSizes[index] ?? TileSize.small;
        final height = columnWidth * heightMultiplier(size);

        if (kDebugMode) print('$index image height = $height');

        return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 500),
          columnCount: columnCount,
          child: ScaleAnimation(
            child: FadeInAnimation(
              child: SizedBox(
                height: height,
                child: imgTileWithGesture(img, heroTag),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget imgTileWithGesture(Wallpaperloader img, String heroTag) {
    return GestureDetector(
      onTap: () {
        ImagePopUp(context: context, img: img, heroTag: heroTag).imagePopUp();
      },
      child: Hero(tag: heroTag, child: imageBox(img)),
    );
  }

  Widget imageBox(Wallpaperloader img) {
    // a scale down version of the full image url
    final int w = 600, q = 90;
    final String thumbnailUrl = '${img.imageUrl}?w=$w&q=$q&fm=webp';

    // url to load full resolution image
    //final String fullResUrl = img.imageUrl;

    return CachedNetworkImage(
      memCacheWidth: w,
      fit: BoxFit.fitWidth,
      imageUrl: thumbnailUrl,
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      placeholder: (context, url) =>
          Center(child: CircularProgressIndicator.adaptive(strokeWidth: 2.0)),
    );
  }
}

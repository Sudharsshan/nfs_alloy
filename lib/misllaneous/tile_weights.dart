import 'dart:math';

enum TileSize { small, medium, large }

final Map<int, TileSize> tileSizes = {};
final Random rng = Random(42); // fixed seed = stable layout

void generateTileSizes(int count) {
  for (int i = 0; i < count; i++) {
    final r = rng.nextDouble();

    if (r < 0.2) {
      tileSizes[i] = TileSize.large; // 20%
    } else if (r < 0.5) {
      tileSizes[i] = TileSize.medium; // 30%
    } else {
      tileSizes[i] = TileSize.small; // 50%
    }
  }
}

import 'dart:html';

import 'resources/resources.dart';
import 'utils.dart';

class Tile extends Drawable {
  bool is_walkable;
  ImageElement img;

  Tile(this.is_walkable, this.img);
  void draw(CanvasRenderingContext2D ctx, Location loc) {
    ctx.drawImageScaled(img, loc.x * TILE_SIZE, loc.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
  }
}

Tile make_dark_ground_tile() {
  return Tile(false, dark_ground_tile_image);
}

Tile make_dark_road_tile() {
  return Tile(true, dark_road_tile_image);
}

Tile make_light_ground_tile() {
  return Tile(false, light_ground_tile_image);
}

Tile make_light_road_tile() {
  return Tile(true, light_road_tile_image);
}

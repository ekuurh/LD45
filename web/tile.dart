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

Tile make_ground_tile() {
  return Tile(false, ground_tile_image);
}
Tile make_road_tile() {
  return Tile(true, road_tile_image);
}
import 'dart:html';

import 'utils.dart';

class Tile {
  bool is_walkable;
  ImageElement img;

  Tile(this.is_walkable, this.img);
  void draw(CanvasRenderingContext2D ctx, Location loc) {
    ctx.drawImageScaled(img, loc.x * TILE_SIZE, loc.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
  }
}

Tile make_ground_tile() {
  return Tile(false, ImageElement(src: 'resources/ground_tile_large.bmp'));
}
Tile make_road_tile() {
  return Tile(true, ImageElement(src: 'resources/road_tile_large.bmp'));
}
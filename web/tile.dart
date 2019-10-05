import 'dart:html';

import 'utils.dart';

class Tile {
  bool is_walkable;
  String color;

  Tile(this.is_walkable, this.color);
  void draw(CanvasRenderingContext2D ctx, Location loc) {
    ctx.fillStyle = color;
    ctx.fillRect(loc.x * TILE_SIZE, loc.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
  }
}

Tile make_red_tile() {
  return Tile(true, "red");
}
Tile make_blue_tile() {
  return Tile(true, "blue");
}
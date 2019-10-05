import 'dart:html';
import 'utils.dart';
import 'tile.dart';

class Map {
  List<List<Tile>> tiles;
  Map(this.tiles);
  void draw(CanvasRenderingContext2D ctx) {
    for(num x = 0; x < tiles.length; x++) {
      for(num y = 0; y < tiles[x].length; y++) {
        tiles[x][y].draw(ctx, Point(x, y));
      }
    }
  }
  int get width => tiles.length;
  int get height => tiles[0].length;
}

import 'dart:html';
import 'utils.dart';
import 'tile.dart';

class Map {
  List<List<Tile>> tiles;
  Map(this.tiles);
  void draw(CanvasElement canvas) {
    for(num x = 0; x < width; x++) {
      for(num y = 0; y < height; y++) {
        tiles[x][y].draw(canvas, Point(x, y));
      }
    }
  }
  int get width => tiles.length;
  int get height => tiles[0].length;
}

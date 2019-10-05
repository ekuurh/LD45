import 'dart:html';
import 'utils.dart';
import 'tile.dart';

class Map {
  List<List<Tile>> tiles;
  Map(this.tiles);
  void draw(CanvasElement canvas) {
    for(num x = 0; x < tiles.length; x++) {
      for(num y = 0; y < tiles[x].length; y++) {
        tiles[x][y].draw(canvas, Point(x, y));
      }
    }
  }
}

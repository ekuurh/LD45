import 'dart:html';
import 'utils.dart';
import 'tile.dart';

class WorldMap {
  List<List<Tile>> tiles;
  WorldMap(this.tiles);
  
  WorldMap.fromString(String s) {
    int i;
    int line, col;
    tiles = List<List<Tile>>();
    line = 0;
    col = 0;
    for (i = 0;i < s.length;i++) {
      String ch = s[i];
      Tile tile = null;
      switch (ch) {
        case "r":
          // Road
          tile = make_road_tile();
          break;
        case "g":
          tile = make_ground_tile();
          break;
        case "\n":
          if (col != 0) {
            // Ignore lines with no tiles
            line++;
            col = 0;
          }
      }
      
      if (tile != null) {
        if (line == 0) {
          List<Tile> new_column = List<Tile>();
          new_column.add(tile);
          tiles.add(new_column);
        }
        else {
          tiles[col].add(tile);
        }
        col++;
      }
    }
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    for(num x = 0; x < tiles.length; x++) {
      for(num y = 0; y < tiles[x].length; y++) {
        tiles[x][y].draw(ctx, Location(x, y));
      }
    }
  }
  int get width => tiles.length;
  int get height => tiles[0].length;
  bool is_valid_location(Location loc) {
    return ((loc.x >= 0) && (loc.x < width) && (loc.y >= 0) && (loc.y < height));
  }
}

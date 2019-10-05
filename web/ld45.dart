import 'dart:html';
import 'tile.dart';
import 'map.dart';
import 'routing.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;

void main() {
  canvas = querySelector('#canvas');
  Map map = new Map([[make_blue_tile(), make_red_tile()], [make_red_tile(), make_blue_tile()]]);
  map.tiles[0][1].is_walkable = false;
  map.draw(canvas);
  print(how_to_get_to(Point(0, 0), Point(1, 1), map));
}
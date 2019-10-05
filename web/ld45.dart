import 'dart:html';
import 'tile.dart';
import 'map.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;

void main() {
  canvas = querySelector('#canvas');
  Map world = new Map([[make_blue_tile(), make_red_tile()], [make_red_tile(), make_blue_tile()]]);
  world.draw(canvas);
}
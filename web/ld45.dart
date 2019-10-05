import 'dart:html';
import 'tile.dart';
import 'world.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;

void main() {
  canvas = querySelector('#canvas');
  World world = new World([[make_blue_tile(), make_red_tile()], [make_red_tile(), make_blue_tile()]]);
  world.draw(canvas);
}
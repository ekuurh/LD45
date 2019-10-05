import 'dart:html';
import 'tile.dart';
import 'world.dart';
import 'map.dart';
import 'routing.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;

void main() async {
  canvas = querySelector('#canvas');
  ctx = canvas.getContext('2d');

  World world = World();

  num prevTime = await window.animationFrame;
  while (true) {
    num time = await window.animationFrame;
    num dt = (time - prevTime) / 1000.0;  // In seconds
    prevTime = time;

    world.update(dt);
    world.draw(ctx);
  }
  Map map = new Map([[make_blue_tile(), make_red_tile()], [make_red_tile(), make_blue_tile()]]);
  map.tiles[0][1].is_walkable = false;
  map.draw(canvas);
  print(how_to_get_to(Point(0, 0), Point(1, 1), map));
}
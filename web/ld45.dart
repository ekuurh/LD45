import 'dart:html';
import 'tile.dart';
import 'world.dart';
import 'map.dart';
import 'routing.dart';
import 'utils.dart';
import 'level.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;

void main() async {
  canvas = querySelector('#canvas');
  ctx = canvas.getContext('2d');

  Map map = new Map([[make_blue_tile(), make_red_tile()], [make_red_tile(), make_blue_tile()]]);
  map.tiles[0][1].is_walkable = false;
  map.draw(ctx);
  print(how_to_get_to(Location(0, 0), Location(1, 1), map));

  World world = World(Level());

  document.onKeyDown.listen(world.player.handle_keydown);
  document.onKeyUp.listen(world.player.handle_keyup);

  num prevTime = await window.animationFrame;
  while (true) {
    num time = await window.animationFrame;
    num dt = (time - prevTime) / 1000.0;  // In seconds
    prevTime = time;

    world.update(dt);
    world.draw(ctx);
  }
}
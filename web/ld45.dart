import 'dart:html';
import 'person.dart';
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

  World world = World(Level());
  world.persons.add(Person([Location(0, 0), Location(2, 1), Location(0, 2)]));

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
import 'dart:html';
import 'tile.dart';
import 'world.dart';

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
}
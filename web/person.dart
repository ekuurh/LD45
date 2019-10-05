import 'utils.dart';
import 'dart:math';
import 'dart:html';

const num WALK_TIME = 1.0;

class Person {
  Point walk_start;
  Point walk_end;
  num walk_progress;
  bool is_walking;
  
  Person() {
    walk_start = Point(0,0);
    walk_end = Point(1,0);
    walk_progress = 0;
    is_walking = true;
  }
  
  void update(num dt) {
    if (is_walking) {
      if (walk_progress < 1.0) {
        walk_progress += dt / WALK_TIME;
        walk_progress = min(walk_progress, 1.0);
      } else {
        is_walking = false;
      }
    }
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    num center_tile_x = 0.5 + interpolate(walk_start.x, walk_end.x, walk_progress);
    num center_tile_y = 0.5 + interpolate(walk_start.y, walk_end.y, walk_progress);
    
    ctx.fillStyle = "#808080";
    ctx.beginPath();
    ctx.ellipse(center_tile_x * TILE_SIZE, center_tile_y * TILE_SIZE, TILE_SIZE * 0.4, TILE_SIZE * 0.4,
      0, 0, pi * 2, false);
    ctx.fill();
  }
}
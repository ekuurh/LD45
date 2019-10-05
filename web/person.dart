import 'utils.dart';
import 'dart:math';
import 'dart:html';

const num WALK_TIME = CLOCK_TIME;

class Person {
  List<Location> waypoints;
  Location location;
  Location next_location;
  num walk_progress;
  num next_waypoint;
  bool is_walking;
  
  Person(this.waypoints) {
    walk_progress = 0;
    next_waypoint = 1;
    is_walking = false;
    location = waypoints[0];
    next_location = waypoints[0]; //how_to_get_to(waypoints[next_waypoint]);
  }
  
  void walk_in_direction(Direction dir) {
    
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
    num center_tile_x = 0.5 + interpolate(location.x, next_location.x, walk_progress);
    num center_tile_y = 0.5 + interpolate(location.y, next_location.y, walk_progress);
    
    ctx.fillStyle = "#808080";
    ctx.beginPath();
    ctx.ellipse(center_tile_x * TILE_SIZE, center_tile_y * TILE_SIZE, TILE_SIZE * 0.4, TILE_SIZE * 0.4,
      0, 0, pi * 2, false);
    ctx.fill();
  }
}
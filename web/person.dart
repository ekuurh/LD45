import 'utils.dart';
import 'dart:math';
import 'dart:html';
import 'routing.dart';
import 'map.dart';

const num WALK_TIME = CLOCK_TIME;

enum PersonState {
  WALKING,
  CONVERSING,
  STAYING
}

class Person {
  List<Location> waypoints;
  Location location;
  Location next_location;
  num belief;
  num walk_progress;
  num next_waypoint;
  PersonState state;
  
  Person(this.waypoints) {
    walk_progress = 0;
    belief = 0;
    next_waypoint = 1;
    state = PersonState.STAYING;
    location = waypoints[0];
    next_location = waypoints[0];
  }

  Direction get_wanted_direction(Map map) {
    num next_waypoint_attempt = next_waypoint;
    print("getting wanted direction");
    do {
      RoutingResult res = how_to_get_to(location, waypoints[next_waypoint_attempt], map);
      if(res != RoutingResult.NAN) {
        next_waypoint = next_waypoint_attempt;
        return routing_result_to_direction(res);
      }
      print("WTFFFF");
      next_waypoint_attempt = (next_waypoint_attempt + 1) % waypoints.length;
    } while(next_waypoint_attempt != next_waypoint);
    return Direction.STAY;
  }
  
  void walk_in_direction(Direction dir) {
    next_location = location_add(location, dir);
    state = PersonState.WALKING;
  }
  
  void set_belief(num belief) {
    this.belief = belief;
  }
  
  void update(num dt) {
    if (state == PersonState.WALKING) {
      if (walk_progress < 1.0) {
        walk_progress += dt / WALK_TIME;
        walk_progress = min(walk_progress, 1.0);
      }
      if (walk_progress >= 1.0) {
        state = PersonState.STAYING;
        location = next_location;
        walk_progress = 0.0;
        if(location == waypoints[next_waypoint]) {
          next_waypoint = (next_waypoint + 1) % waypoints.length;
        }
      }
    }
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    num center_tile_x = 0.5 + interpolate(location.x, next_location.x, walk_progress);
    num center_tile_y = 0.5 + interpolate(location.y, next_location.y, walk_progress);
    
    if (belief == 0)
      ctx.fillStyle = "#808080";
    else
      ctx.fillStyle = "#ff8080";
    ctx.beginPath();
    ctx.ellipse(center_tile_x * TILE_SIZE, center_tile_y * TILE_SIZE, TILE_SIZE * 0.4, TILE_SIZE * 0.4,
      0, 0, pi * 2, false);
    ctx.fill();
  }
}
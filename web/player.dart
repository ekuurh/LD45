import 'dart:html';
import 'package:tuple/tuple.dart';

import 'obstacle.dart';
import 'utils.dart';
import 'world.dart';
import 'person.dart';

const num PLAYER_SPEED = 2.0;
const num MAX_ACTION_DISTANCE = 0.8;

class Player {
  World world;
  num speed_x, speed_y;
  num x, y;
  Player(this.world) {
    speed_x = 0;
    speed_y = 0;
    x = 1;
    y = 1;
  }
  
  void perform_action() {
    var loc = Location(x+0.5, y+0.5);
    Tuple2<Object, num> closest = world.closest_object_to(loc);
    if(closest.item2 > MAX_ACTION_DISTANCE) {
      return;
    }
    if (closest.item1 is Person) {
      Person p = closest.item1;
      p.set_belief(1);
    }
    if (closest.item1 is Tuple2) {
      Tuple2<Obstacle, Location> tup = closest.item1;
      if(tup.item1 is FallingObstacle) {
        FallingObstacle obstacle = tup.item1;
        Tuple2<StaticObstacle, Location> new_obstacle = obstacle.do_action(this, tup.item2);
        for(num ind = 0; ind < world.obstacles.length; ind++) {
          if(world.obstacles[ind].item1 == obstacle) {
            world.obstacles[ind] = new_obstacle;
          }
        }
        world.recompute_is_walkable_arr();
      }
    }
  }
  
  void handle_keydown(KeyboardEvent e) {
    switch (e.key) {
      case "ArrowRight":
        speed_x =PLAYER_SPEED;
        e.preventDefault();
        break;
      case "ArrowLeft":
        speed_x = -PLAYER_SPEED;
        e.preventDefault();
        break;
      case "ArrowDown":
        speed_y = PLAYER_SPEED;
        e.preventDefault();
        break;
      case "ArrowUp":
        speed_y = -PLAYER_SPEED;
        e.preventDefault();
        break;
      case " ":
        perform_action();
        e.preventDefault();
    }
  }
  
  void handle_keyup(KeyboardEvent e) {
    switch (e.key) {
      case "ArrowRight":
      case "ArrowLeft":
        speed_x = 0;
        break;
      case "ArrowUp":
      case "ArrowDown":
        speed_y = 0;
    }
  }
  
  void update(num dt) {
    x += speed_x * dt;
    y += speed_y * dt;
    x = clamp(x, 0, world.map.width - 1);
    y = clamp(y, 0, world.map.height - 1);
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    ctx.fillStyle = "#ffff00";
    ctx.fillRect(((x + 0.1) * TILE_SIZE).round(), ((y + 0.1) * TILE_SIZE).round(),
      (TILE_SIZE * 0.8).round(), (TILE_SIZE * 0.8).round());
  }
}
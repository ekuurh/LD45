import 'dart:html';
import 'package:tuple/tuple.dart';

import 'obstacle.dart';
import 'utils.dart';
import 'world.dart';
import 'person.dart';

const num PLAYER_SPEED = 2.0;
const num MAX_ACTION_DISTANCE = 0.8;

const num SUGGESTION_MANA_USAGE = 20;
const num INTERACTION_MANA_USAGE = 10;

class Player {
  World world;
  num speed_x, speed_y;
  num x, y;
  num mana;
  Location mana_bar_loc, mana_bar_size;

  Player(this.world) {
    speed_x = 0;
    speed_y = 0;
    x = 1;
    y = 1;
    mana = world.starting_mana;
    mana_bar_loc = Location(world.map.width / 15.0, world.map.height / 15.0);
    mana_bar_size = Location(world.map.width / 2.5, world.map.height / 8.0);
  }
  
  void perform_action() {
    var loc = Location(x+0.5, y+0.5);
    Tuple2<Object, num> closest = world.closest_object_to(loc);
    if(closest.item2 > MAX_ACTION_DISTANCE) {
      return;
    }
    if (closest.item1 is Person) {
      if(mana < SUGGESTION_MANA_USAGE) {
        // Not enough mana
        return;
      }
      mana -= SUGGESTION_MANA_USAGE;
      Person p = closest.item1;
      p.set_belief(MAX_BELIEF);
    }
    if (closest.item1 is Tuple2) {
      Tuple2<Obstacle, Location> tup = closest.item1;
      if(tup.item1 is FallingObstacle) {
        FallingObstacle obstacle = tup.item1;
        if(mana < INTERACTION_MANA_USAGE) {
          // Not enough mana
          return;
        }
        mana -= INTERACTION_MANA_USAGE;
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
      case "r":
        world.force_restart();
        break;
      case "R":
        world.force_restart();
        break;
      case " ":
        {
          perform_action();
          e.preventDefault();
        }
        break;
      case "m":
        {
          is_muted = !is_muted;
          print(is_muted);
          world.update_mute();
        }
        break;
      case "M":
        {
          is_muted = !is_muted;
          print(is_muted);
          world.update_mute();
        }
        break;
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

  void draw_mana(CanvasRenderingContext2D ctx) {
    // mana back
    ctx.fillStyle = "rgb(30, 30, 30, 0.1)";
    Location absolute_mana_pos = Location((mana_bar_loc.x * TILE_SIZE).round(), (mana_bar_loc.y * TILE_SIZE).round());
    Location absolute_mana_size = Location((mana_bar_size.x * TILE_SIZE).round(), (mana_bar_size.y * TILE_SIZE).round());
    ctx.fillRect(absolute_mana_pos.x, absolute_mana_pos.y, absolute_mana_size.x, absolute_mana_size.y);

    // mana content
    ctx.fillStyle = "rgb(200, 30, 200, 0.85)";
    ctx.fillRect(absolute_mana_pos.x, absolute_mana_pos.y, (absolute_mana_size.x * mana/100.0).round(), absolute_mana_size.y);

    // mana outline
    ctx.strokeStyle = "rgb(30, 30, 30, 0.85)";
    ctx.lineWidth = (absolute_mana_size.y / 8.0);
    ctx.strokeRect(absolute_mana_pos.x, absolute_mana_pos.y, absolute_mana_size.x, absolute_mana_size.y);

    ctx.fillStyle = "rgb(0, 0, 0, 1)";
    ctx.strokeStyle = "rgb(0, 0, 0, 1)";
  }
}
import 'dart:html';
import 'package:tuple/tuple.dart';
import 'dart:math' as math;
import 'dynamic_sprite.dart';
import 'obstacle.dart';
import 'resources/resources.dart';
import 'utils.dart';
import 'world.dart';
import 'person.dart';
import 'package:mutex/mutex.dart';

const num PLAYER_SPEED = 2.0;
const num MAX_PERSON_ACTION_DISTANCE = 0.8;
const num MAX_TREE_ACTION_DISTANCE = 1.5;

const num SUGGESTION_MANA_USAGE = 20;
const num INTERACTION_MANA_USAGE = 10;

const num POSSESSION_INITIAL_MANA_USAGE = 10;
const num POSSESSION_CONTINUOUS_MANA_USAGE = 5;

const Duration spacebar_time_until_possessing = Duration(milliseconds: 200);

DateTime spacebar_start_time;

class Player {
  World world;
  num speed_x, speed_y;
  num x, y;
  num mana;
  bool is_possessing;
  Location mana_bar_loc, mana_bar_size;
  Location suggestion_orb_loc;
  num suggestion_orb_radius;
  Person possession_targeted_player;
  Mutex update_key_mutex;
  DynamicSprite sprite;
  num suggestions_left;

  Player(this.world) {
    speed_x = 0;
    speed_y = 0;
    suggestions_left = 2;
    x = 1;
    y = 1;
    mana = world.starting_mana;
    mana_bar_loc = Location(world.map.width / 15.0, world.map.height / 15.0);
    mana_bar_size = Location(world.map.width / 2.5, world.map.height / 8.0);
    suggestion_orb_loc = Location(world.map.width / 15.0, world.map.height / 4.5);
    suggestion_orb_radius = world.map.width / 40.0;
    is_possessing = false;
    update_key_mutex = new Mutex();
    sprite = make_player_sprite();
  }
  
  void perform_action() {
    var loc = Location(x+0.5, y+0.5);
    Tuple2<Object, num> closest = world.closest_object_to(loc);
    if(closest.item2 > MAX_TREE_ACTION_DISTANCE) {
      return;
    }
    if((closest.item1 is Person) && (closest.item2 > MAX_PERSON_ACTION_DISTANCE)) {
      return;
    }
    if (closest.item1 is Person) {
      if(mana < SUGGESTION_MANA_USAGE) {
        // Not enough mana
        return;
      }
      Person p = closest.item1;
      if(p.belief < 0) {
        return;
      }
      if(p.belief == 2) {
        return;
      }
      if(suggestions_left == 0) {
        // Can't suggest anymore
        return;
      }
      suggestions_left -= 1;
      mana -= SUGGESTION_MANA_USAGE;
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
        Tuple3<bool, Obstacle, Location> new_obstacle = obstacle.do_action(this, tup.item2);
        if(!new_obstacle.item1) {
          // Could not fall
          return;
        }
        mana -= INTERACTION_MANA_USAGE;
        for(num ind = 0; ind < world.obstacles.length; ind++) {
          if(world.obstacles[ind].item1 == obstacle) {
            world.obstacles[ind] = Tuple2<Obstacle, Location>(new_obstacle.item2, new_obstacle.item3);
          }
        }
        world.recompute_is_walkable_arr();
      }
    }
  }
  
  void handle_keydown(KeyboardEvent e) {
    if(world.state != WorldState.ONGOING) {
      return;
    }
    update_key_mutex.acquire();
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
          if(possession_targeted_player != null) {
            // Already pressed
            break;
          }
          var loc = Location(x+0.5, y+0.5);
          Tuple2<Object, num> closest = world.closest_object_to(loc);
          if(closest.item2 > MAX_TREE_ACTION_DISTANCE) {
            return;
          }
          if((closest.item1 is Person) && (closest.item2 > MAX_PERSON_ACTION_DISTANCE)) {
            return;
          }
          if ((closest.item1 is Person) && (mana >= POSSESSION_INITIAL_MANA_USAGE)) {
            Person person = closest.item1;
            if(person.belief > 0) {
              possession_targeted_player = closest.item1;
              spacebar_start_time = DateTime.now();
            }
          }
          e.preventDefault();
        }
        break;
      case "m":
        {
          is_muted = !is_muted;
          world.update_mute();
        }
        break;
      case "M":
        {
          is_muted = !is_muted;
          world.update_mute();
        }
        break;
      case "f":
        {
          CLOCK_TIME = FAST_CLOCK_TIME;
        }
        break;
      case "F":
        {
          CLOCK_TIME = FAST_CLOCK_TIME;
        }
        break;
    }
    update_key_mutex.release();
  }
  
  void handle_keyup(KeyboardEvent e) {
    if(world.state != WorldState.ONGOING) {
      return;
    }
    update_key_mutex.acquire();
    switch (e.key) {
      case "ArrowRight":
      case "ArrowLeft":
        speed_x = 0;
        break;
      case "ArrowUp":
      case "ArrowDown":
        speed_y = 0;
        break;
      case " ":
        {
          if(possession_targeted_player != null) {
            if(possession_targeted_player.state != PersonState.POSSESSED) {
              // Possession broken by conversation
              mana = (mana/10).ceil() * 10;
              is_possessing = false;
              possession_targeted_player = null;
              spacebar_start_time = null;
              break;
            }
            if(is_possessing) {
              mana = (mana/10).ceil() * 10;
              possession_targeted_player.unpossess();
              is_possessing = false;
            }
            possession_targeted_player = null;
            spacebar_start_time = null;
            break;
          }
          perform_action();
        }
        break;
      case "f":
        {
          CLOCK_TIME = REGULAR_CLOCK_TIME;
        }
        break;
      case "F":
        {
          CLOCK_TIME = REGULAR_CLOCK_TIME;
        }
        break;
    }
    update_key_mutex.release();
  }
  
  void update(num dt) {
    update_key_mutex.acquire();
    x += speed_x * dt / CLOCK_TIME;
    y += speed_y * dt / CLOCK_TIME;
    x = clamp(x, 0, world.map.width - 1);
    y = clamp(y, 0, world.map.height - 1);
    if(possession_targeted_player != null) {
      if (is_possessing) {
        if(mana < dt * POSSESSION_CONTINUOUS_MANA_USAGE) {
          possession_targeted_player.unpossess();
          mana = (mana/10).ceil() * 10;
          is_possessing = false;
          possession_targeted_player = null;
          spacebar_start_time = null;
        }
        else {
          mana -= dt * POSSESSION_CONTINUOUS_MANA_USAGE / CLOCK_TIME;
        }
      }
      else {
        if (DateTime.now().difference(spacebar_start_time) >
            spacebar_time_until_possessing) {
          possession_targeted_player.possess();
          is_possessing = true;
          mana -= POSSESSION_INITIAL_MANA_USAGE;
        }
      }
    }
    update_key_mutex.release();
    sprite.update(dt);
  }
  
  void draw(CanvasRenderingContext2D ctx) {
//    ctx.fillStyle = "#ffff00";
//    ctx.fillRect(((x + 0.1) * TILE_SIZE).round(), ((y + 0.1) * TILE_SIZE).round(),
//      (TILE_SIZE * 0.8).round(), (TILE_SIZE * 0.8).round());
    sprite.draw(ctx, Location(x, y));
  }

  void draw_mana(CanvasRenderingContext2D ctx) {
    // mana back
    ctx.fillStyle = "rgb(30, 30, 30, 0.1)";
    Location absolute_mana_pos = Location((mana_bar_loc.x * TILE_SIZE).round(), (mana_bar_loc.y * TILE_SIZE).round());
    Location absolute_mana_size = Location((mana_bar_size.x * TILE_SIZE).round(), (mana_bar_size.y * TILE_SIZE).round());
    ctx.drawImageScaled(all_manabars[(mana/10).ceil()], absolute_mana_pos.x, absolute_mana_pos.y, absolute_mana_size.x, absolute_mana_size.y);
  }

  void draw_suggestion_orbs(CanvasRenderingContext2D ctx) {
    print("!!");
    ctx.fillStyle = "rgb(120, 0, 120, 0.8)";
    Location absolute_orb_pos = Location((suggestion_orb_loc.x * TILE_SIZE).round(), (suggestion_orb_loc.y * TILE_SIZE).round());
    num absolute_orb_radius = suggestion_orb_radius * TILE_SIZE;
    for(var ind = 0; ind < suggestions_left; ind++) {
//      print([((absolute_orb_pos.x + (ind + 0.5) * absolute_orb_radius) * TILE_SIZE).round(), ((absolute_orb_pos.y + 0.5 * absolute_orb_radius) * TILE_SIZE).round()]);
      ctx.beginPath();
      ctx.ellipse(
          (absolute_orb_pos.x + (2*ind + 1) * absolute_orb_radius).round(),
          (absolute_orb_pos.y + 0.5 * absolute_orb_radius).round(),
          (absolute_orb_radius * 0.8).round(),
          (absolute_orb_radius * 0.8).round(),
          0,
          0,
          math.pi * 2,
          false);
      ctx.fill();
    }

    ctx.fillStyle = "rgb(0, 0, 0, 1)";
  }
}
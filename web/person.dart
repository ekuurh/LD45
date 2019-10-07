import 'package:tuple/tuple.dart';
import 'dynamic_sprite.dart';
import 'persona_sounds.dart';
import 'utils.dart';
import 'dart:math';
import 'dart:html';
import 'routing.dart';
import 'worldmap.dart';
import 'package:color/color.dart';
import 'resources/resources.dart';
import 'belief_table.dart';

const num WALK_TIME = 1;
const num CONVERSATION_TIME = 3;
const num MAX_BELIEF = 2;
const num MANA_EARNED_FROM_CONVERSION = 10;

enum PersonState {
  WALKING,
  CONVERSING,
  POST_CONVERSATION,
  STAYING,
  WAITING,
  POSSESSED
}

class Person extends Drawable {
  List<Tuple2<Location, num>> waypoints_and_waits;
  Location location;
  Location next_location;
  num belief;
  num next_belief;
  num walk_progress;
  num conversation_progress;
  num next_waypoint;
  num wait_time_left;
  Person conversation_buddy;
  PersonState state;
  DynamicSprite sprite;
  PersonaSounds sounds;
  bool is_targeted;
  
  Person(this.waypoints_and_waits, {this.belief = -1}) {
    walk_progress = 0;
    conversation_progress = 0;
    next_belief = -1;
    next_waypoint = 1;
    wait_time_left = 0;
    state = PersonState.STAYING;
    location = waypoints_and_waits[0].item1;
    next_location = location;
    is_targeted = false;
    update_sprite();
    sounds = pick_elements_from_list<PersonaSounds>(all_persona_sounds, 1).first;
  }

  Direction get_desired_direction(WorldMap map, List<List<bool>> is_walkable_arr, Location rounded_player_loc) {
    assert(state != PersonState.WALKING); // Since walk should have ended by now
    if(state == PersonState.CONVERSING) {
      return Direction.STAY;
    }
    if(state == PersonState.WAITING) {
      return Direction.STAY;
    }
    if(state == PersonState.POSSESSED) {
      RoutingResult res = how_to_get_to(location, rounded_player_loc, map, is_walkable_arr);
//      print([[location.x, location.y], [rounded_player_loc.x, rounded_player_loc.y], res]);
      if(res == RoutingResult.NAN) {
        return Direction.STAY;
      }
      return routing_result_to_direction(res);
    }
    num next_waypoint_attempt = next_waypoint;
    do {
      RoutingResult res = how_to_get_to(location, waypoints_and_waits[next_waypoint_attempt].item1, map, is_walkable_arr);
      if(res != RoutingResult.NAN) {
        next_waypoint = next_waypoint_attempt;
        return routing_result_to_direction(res);
      }
      next_waypoint_attempt = (next_waypoint_attempt + 1) % waypoints_and_waits.length;
    } while(next_waypoint_attempt != next_waypoint);
    return Direction.STAY;
  }
  
  void walk_in_direction(Direction dir) {
    next_location = location_add(location, dir);
    if(state != PersonState.POSSESSED) {
      state = PersonState.WALKING;
    }
    update_sprite();
  }
  
  void set_belief(num belief) {
    this.belief = belief;
    update_sprite();
  }
  
  void update(num dt) {
    if(state == PersonState.WAITING) {
      wait_time_left -= dt / CLOCK_TIME;
      if(wait_time_left <= 0.0) {
        wait_time_left = 0.0;
        state = PersonState.STAYING;
        update_sprite();
      }
    }
    if ((state == PersonState.WALKING) || (state == PersonState.POSSESSED)) {
      if(state == PersonState.WALKING) {
        assert(verbosify((location.x != next_location.x) || (location.y != next_location.y), "Internal error #2"));
      }
      if((state == PersonState.POSSESSED) && (location.x == next_location.x) && (location.y == next_location.y)) {
        return;
      }
      if (walk_progress < 1.0) {
        walk_progress += dt / (WALK_TIME * CLOCK_TIME);
        walk_progress = min(walk_progress, 1.0);
      }
      if (walk_progress >= 1.0) {
        location = next_location;
        if(state == PersonState.WALKING) {
          state = PersonState.STAYING;
          update_sprite();
        }
        walk_progress = 0.0;
        if((state == PersonState.STAYING) && (location.x == waypoints_and_waits[next_waypoint].item1.x) && (location.y == waypoints_and_waits[next_waypoint].item1.y)) {
          wait_time_left = waypoints_and_waits[next_waypoint].item2;
          next_waypoint = (next_waypoint + 1) % waypoints_and_waits.length;
          if(wait_time_left > 0) {
            state = PersonState.WAITING;
            update_sprite();
          }
        }
      }
    }
    if(state == PersonState.CONVERSING) {
      if (conversation_progress < 1.0) {
        conversation_progress += dt / (CONVERSATION_TIME * CLOCK_TIME);
        conversation_progress = min(conversation_progress, 1.0);
      }
      if(conversation_progress >= 1.0) {
        state = PersonState.POST_CONVERSATION;
        belief = next_belief;
        conversation_progress = 0.0;
        update_sprite();
      }
    }
    sprite.update(dt);
  }

  num start_conversing(Person buddy, num new_belief) {
    assert(verbosify((state == PersonState.STAYING) || (state == PersonState.POSSESSED) || (state == PersonState.WAITING),
                     "Trying to start a conversation when I am ${state}"));
    if(state == PersonState.POSSESSED) {
      unpossess();
    }
    state = PersonState.CONVERSING;
    wait_time_left = 0.0; // prematurely end any wait there might have been
    conversation_progress = 0.0;
    conversation_buddy = buddy;
    next_belief = new_belief;
    if((belief <= 0) && (new_belief > 0)) {
      return MANA_EARNED_FROM_CONVERSION;
    }
    update_sprite();
    return 0;
  }

  Location get_interpolated_location() {
    return Location(interpolate(location.x, next_location.x, walk_progress),
                    interpolate(location.y, next_location.y, walk_progress));
  }

  num get_interpolated_belief() {
    return interpolate(belief, next_belief, conversation_progress);
  }

  void possess() {
    print("POSSESSED!");
    state = PersonState.POSSESSED;
    update_sprite();
  }

  bool am_walking() {
    return ((location.x != next_location.x) || (location.y != next_location.y));
  }

  void update_sprite() {
    if(state == PersonState.CONVERSING) {
      if(conversation_buddy.location.x < location.x) {
        sprite = talking_person_sprites[Tuple2<bool, num>(false, belief)];
      }
      else {
        sprite = talking_person_sprites[Tuple2<bool, num>(true, belief)];
      }
    }
    else {
      sprite = get_person_sprite(
          am_walking(), state == PersonState.POSSESSED, is_targeted, belief);
    }
  }

  void unpossess() {
    if(walk_progress != 0.0) {
      state = PersonState.WALKING;
    }
    else {
      state = PersonState.STAYING;
    }
    update_sprite();
  }
  
  void draw_impl(CanvasRenderingContext2D ctx) {
    Location interpolated_loc = get_interpolated_location();
    sprite.draw(ctx, interpolated_loc);
  }

  void target() {
    is_targeted = true;
    update_sprite();
  }

  void untarget() {
    is_targeted = false;
    update_sprite();
  }

  void draw(CanvasRenderingContext2D ctx, Location loc) {
    assert(verbosify((loc.x == location.x) && (loc.y == location.y), "Weird..."));
    draw_impl(ctx);
  }
}

List<Person> pesrons_from_string(String s) {
  List<Person> ret = List<Person>();
  for(String line in s.split('\n')) {
    String curr = line;
    curr = curr.replaceAll(' ', '');
    curr = curr.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    if(curr.length == 0) {
      continue;
    }
    List<Tuple2<Location, num> > waypoints_and_waits = [];
    List<String> parts = curr.split('|');
    assert(verbosify(parts.length >= 2, "Error in person parsing, not enough delimiters: '${curr}'"));
    String last = parts.removeLast();
    num belief = verbose_parse_string(last, "ERROR in person - could not parse number '${last}'");
    for(String part in parts) {
      List<String> tmp = part.split(';');
      assert(verbosify(tmp.length == 2, "Error in person parsing: problem with semicolons in '${part}'"));
      List<String> pos = tmp[0].split(',');
      assert(verbosify(pos.length == 2, "Error in person parsing: unexpected '${pos}' in '${part}'"));
      int pos0 = verbose_parse_string(pos[0], "ERROR in person - could not parse number '${pos[0]}'");
      int pos1 = verbose_parse_string(pos[1], "ERROR in person - could not parse number '${pos[1]}'");
      int tmp1 = verbose_parse_string(tmp[1], "ERROR in person - could not parse number '${tmp[1]}'");
      waypoints_and_waits.add(Tuple2<Location, num>(Location(pos0, pos1), tmp1));
    }
    ret.add(Person(waypoints_and_waits, belief: belief));
  }
  return ret;
}

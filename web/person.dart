import 'package:tuple/tuple.dart';
import 'utils.dart';
import 'dart:math';
import 'dart:html';
import 'routing.dart';
import 'worldmap.dart';
import 'package:color/color.dart';
import 'belief_table.dart';

const num WALK_TIME = CLOCK_TIME;
const num CONVERSATION_TIME = 3 * CLOCK_TIME;
const num MAX_BELIEF = 2;
ImageElement person_image = ImageElement(src: "resources/images/sprite_test.png");

enum PersonState {
  WALKING,
  CONVERSING,
  POST_CONVERSATION,
  STAYING,
  WAITING
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
  
  Person(this.waypoints_and_waits, {this.belief = -1}) {
    walk_progress = 0;
    conversation_progress = 0;
    next_belief = -1;
    next_waypoint = 1;
    wait_time_left = 0;
    state = PersonState.STAYING;
    location = waypoints_and_waits[0].item1;
    next_location = location;
  }

  Direction get_desired_direction(WorldMap map, List<List<bool>> is_walkable_arr) {
    assert(state != PersonState.WALKING); // Since walk should have ended by now
    if(state == PersonState.CONVERSING) {
      return Direction.STAY;
    }
    if(state == PersonState.WAITING) {
      return Direction.STAY;
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
    state = PersonState.WALKING;
  }
  
  void set_belief(num belief) {
    this.belief = belief;
  }
  
  void update(num dt) {
    if(state == PersonState.WAITING) {
      wait_time_left -= dt;
      if(wait_time_left <= 0.0) {
        wait_time_left = 0.0;
        state = PersonState.STAYING;
      }
    }
    if (state == PersonState.WALKING) {
      if (walk_progress < 1.0) {
        walk_progress += dt / WALK_TIME;
        walk_progress = min(walk_progress, 1.0);
      }
      if (walk_progress >= 1.0) {
        location = next_location;
        state = PersonState.STAYING;
        walk_progress = 0.0;
        if((location.x == waypoints_and_waits[next_waypoint].item1.x) && (location.y == waypoints_and_waits[next_waypoint].item1.y)) {
          next_waypoint = (next_waypoint + 1) % waypoints_and_waits.length;
          wait_time_left = waypoints_and_waits[next_waypoint].item2 * CLOCK_TIME;
          if(wait_time_left > 0) {
            state = PersonState.WAITING;
          }
        }
      }
    }
    if(state == PersonState.CONVERSING) {
      if (conversation_progress < 1.0) {
        conversation_progress += dt / CONVERSATION_TIME;
        conversation_progress = min(conversation_progress, 1.0);
      }
      if(conversation_progress >= 1.0) {
        state = PersonState.POST_CONVERSATION;
        belief = next_belief;
        conversation_progress = 0.0;
      }
    }
  }

  void start_conversing(Person buddy, num new_belief) {
    assert(state == PersonState.STAYING);
    state = PersonState.CONVERSING;
    conversation_progress = 0.0;
    conversation_buddy = buddy;
    next_belief = new_belief;
  }

  Location get_interpolated_location() {
    return Location(interpolate(location.x, next_location.x, walk_progress),
                    interpolate(location.y, next_location.y, walk_progress));
  }

  num get_interpolated_belief() {
    return interpolate(belief, next_belief, conversation_progress);
  }
  
  void draw_impl(CanvasRenderingContext2D ctx) {
    Location interpolated_loc = get_interpolated_location();
//    ctx.drawImageScaled(person_image, interpolated_loc.x * TILE_SIZE, interpolated_loc.y * TILE_SIZE,
//        TILE_SIZE, TILE_SIZE);

    num center_tile_x = 0.5 + interpolated_loc.x;
    num center_tile_y = 0.5 + interpolated_loc.y;

    num normalized_interpolated_belief = get_interpolated_belief() / (MAX_BELIEF * 1.0);
    ctx.fillStyle = RgbColor(255*(1+normalized_interpolated_belief)/2, 255/2, 255*(1-normalized_interpolated_belief)/2).toHexColor().toCssString();

    ctx.beginPath();
    if(state != PersonState.CONVERSING) {
      ctx.ellipse(
          center_tile_x * TILE_SIZE,
          center_tile_y * TILE_SIZE,
          TILE_SIZE * 0.4,
          TILE_SIZE * 0.4,
          0,
          0,
          pi * 2,
          false);
    }
    else {
      ctx.ellipse(
          center_tile_x * TILE_SIZE,
          center_tile_y * TILE_SIZE,
          TILE_SIZE * 0.2,
          TILE_SIZE * 0.2,
          0,
          0,
          pi * 2,
          false);
    }
    ctx.fill();
  }

  void draw(CanvasRenderingContext2D ctx, Location loc) {
    assert(verbosify((loc.x == location.x) && (loc.y == location.y), "Weird..."));
    draw_impl(ctx);
  }
}

void start_conversation(Person first, Person second) {
  Tuple2<num, num> next_beliefs = null;
  Tuple2<num, num> belief_tup = Tuple2<num, num>(first.belief, second.belief);
  if(belief_table.containsKey(belief_tup)) {
    next_beliefs = belief_table[belief_tup];
  }
  Tuple2<num, num> reverse_belief_tup = Tuple2<num, num>(second.belief, first.belief);
  if(belief_table.containsKey(reverse_belief_tup)) {
    next_beliefs = Tuple2<num, num>(belief_table[reverse_belief_tup].item2, belief_table[reverse_belief_tup].item1);
  }
  assert(verbosify(next_beliefs != null, "Don't know what to do when the beliefs are (${first.belief}, ${second
      .belief})!"));

  first.start_conversing(second, next_beliefs.item1);
  second.start_conversing(first, next_beliefs.item2);
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
      assert(verbosify(tmp.length == 2, "Error in person parsing"));
      List<String> pos = tmp[0].split(',');
      assert(verbosify(pos.length == 2, "Error in person parsing"));
      int pos0 = verbose_parse_string(pos[0], "ERROR in person - could not parse number '${pos[0]}'");
      int pos1 = verbose_parse_string(pos[1], "ERROR in person - could not parse number '${pos[1]}'");
      int tmp1 = verbose_parse_string(tmp[1], "ERROR in person - could not parse number '${tmp[1]}'");
      waypoints_and_waits.add(Tuple2<Location, num>(Location(pos0, pos1), tmp1));
      print([pos0, pos1, tmp1]);
    }
    ret.add(Person(waypoints_and_waits, belief: belief));
  }
  return ret;
}

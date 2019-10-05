import 'utils.dart';
import 'dart:math';
import 'dart:html';
import 'routing.dart';
import 'map.dart';

const num WALK_TIME = CLOCK_TIME;
const num CONVERSATION_TIME = 3 * CLOCK_TIME;

enum PersonState {
  WALKING,
  CONVERSING,
  POST_CONVERSATION,
  STAYING
}

class Person {
  List<Location> waypoints;
  Location location;
  Location next_location;
  num belief;
  num walk_progress;
  num conversation_progress;
  num next_waypoint;
  Person conversation_buddy;
  PersonState state;
  
  Person(this.waypoints) {
    walk_progress = 0;
    conversation_progress = 0;
    belief = 0;
    next_waypoint = 1;
    state = PersonState.STAYING;
    location = waypoints[0];
    next_location = waypoints[0];
  }

  Direction get_desired_direction(Map map) {
    assert(state != PersonState.WALKING); // Since walk should have ended by now
    if(state == PersonState.CONVERSING) {
      return Direction.STAY;
    }
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
    if(state == PersonState.CONVERSING) {
      if (conversation_progress < 1.0) {
        conversation_progress += dt / CONVERSATION_TIME;
        conversation_progress = min(conversation_progress, 1.0);
      }
      if(conversation_progress >= 1.0) {
        state = PersonState.POST_CONVERSATION;
        conversation_progress = 0.0;
      }
    }
  }

  void start_conversing(Person buddy) {
    assert(state == PersonState.STAYING);
    state = PersonState.CONVERSING;
    conversation_progress = 0.0;
    conversation_buddy = buddy;
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    num center_tile_x = 0.5 + interpolate(location.x, next_location.x, walk_progress);
    num center_tile_y = 0.5 + interpolate(location.y, next_location.y, walk_progress);
    
    if (belief == 0)
      ctx.fillStyle = "#808080";
    else
      ctx.fillStyle = "#ff8080";
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
}

void start_conversation(Person first, Person second) {
  first.start_conversing(second);
  second.start_conversing(first);
}

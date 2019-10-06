import 'dart:core';
import 'dart:html';
import 'dart:math';
import 'package:collection/collection.dart';
import 'obstacle.dart';
import 'resources/resources.dart';
import 'utils.dart';
import 'tile.dart';
import 'worldmap.dart';
import 'person.dart';
import 'level.dart';
import 'dart:collection';
import 'package:tuple/tuple.dart';
import 'player.dart';
import 'obstacle.dart';
import 'package:howler/howler.dart';

const num TINT_TIME = 0.3;
const num MAX_TINT = 0.5;

const num WINLOSE_SCREEN_MAX_RELATIVE_WIDTH = 0.8;
const num WINLOSE_SCREEN_MAX_RELATIVE_HEIGHT = 0.4;

enum WorldState {
  ONGOING,
  LOSE_SCREEN,
  LOSE,
  WIN_SCREEN,
  WIN,
  BOOTING
}

class World {
  WorldMap map;
  List<Person> persons;
  List<Tuple2<Obstacle, Location> > obstacles;
  num clock_progress;
  Player player;
  WorldState state;
  List<List<bool>> is_walkable_arr;
  Howl music;
  num starting_mana;
  num tint_level;
  ImageElement win_screen;

  void recompute_is_walkable_arr() {
    is_walkable_arr = List<List<bool>>();

    for(num x = 0; x < map.width; x++) {
      is_walkable_arr.add(List<bool>());
      for(num y = 0; y < map.height; y++) {
        is_walkable_arr[x].add(map.tiles[x][y].is_walkable);
      }
    }
    for(Tuple2<Obstacle, Location> obstacle in obstacles) {
      for(var i = -obstacle.item1.occupy_dimensions.item1+1; i <= 0; i++) {
        for(var j = -obstacle.item1.occupy_dimensions.item2+1; j <= 0; j++) {
          is_walkable_arr[obstacle.item2.x + i][obstacle.item2.y + j] = false;
        }
      }
    }
  }

  void update_mute() {
    music.mute(is_muted);
  }

  World(Level level, bool start_music) {
    map = level.map;
    win_screen = level.win_screen;
    persons = [];
    for(var person in level.persons) {
      persons.add(Person(person.waypoints_and_waits, belief: person.belief));
    }
    state = WorldState.BOOTING;
    tint_level = MAX_TINT;
    obstacles = [];
    for(var obstacle in level.obstacles) {
      obstacles.add(obstacle);
    }
    music = level.music;
    recompute_is_walkable_arr();
    if((music != null) && (start_music)) {
      music.play();
      music.fade(0, 0.6, 1000);
      update_mute();
    }
    clock_progress = 0;
    starting_mana = level.starting_mana;
    player = Player(this); // last in init since it uses "this"
    do_routing();
  }
  
  Tuple2<Object, num> closest_object_to(Location p) {
    num min_dist = 99999999999;
    Object result = null;
    for (Person person in persons) {
      if(person.state == PersonState.CONVERSING) { // We can't convert mid-conversation
        continue;
      }
      Location interpolated_loc = person.get_interpolated_location();
      num dist = Location.distance(Location(interpolated_loc.x+0.5, interpolated_loc.y+0.5), p);
      if (dist < min_dist) {
        min_dist = dist;
        result = person;
      }
    }
    for(Tuple2<Obstacle, Location> obstacle in obstacles) {
      if(obstacle.item1 is FallingObstacle) {
        num dist = Location.distance(Location(obstacle.item2.x+(2-obstacle.item1.draw_dimensions.item1)/2.0, obstacle.item2.y+(2-obstacle.item1.draw_dimensions.item2)/2.0), p);
        if (dist < min_dist) {
          min_dist = dist;
          result = obstacle;
        }
      }
    }
    return Tuple2<Object, num>(result, min_dist);
  }

  void do_routing() {
    Location rounded_player_loc = Location(player.x.round(), player.y.round());
    Map<Person, Direction> person_to_direction = {};
    Map<Person, Tuple2<num, num>> person_to_desired_location = {};
    Map<Tuple2<num, num>, List> location_to_desiring_persons = {};
    for(var person in persons) {
      Direction dir = person.get_desired_direction(map, is_walkable_arr, rounded_player_loc);
      person_to_direction[person] = dir;
      var wanted_loc = location_add(person.location, dir);
      var wanted_loc_tup = Tuple2<num, num>(wanted_loc.x, wanted_loc.y);
      var curr_list = location_to_desiring_persons[wanted_loc_tup];
      if(curr_list == null) {
        curr_list = [];
      }
      curr_list.add(person);
      location_to_desiring_persons[wanted_loc_tup] = curr_list;
      person_to_desired_location[person] = wanted_loc_tup;
    }

    // Find newly conversing pairs:
    for(var person in persons) {
//      if(person_to_direction[person] == Direction.STAY) {
//        continue;
//      }
      if(person.state == PersonState.POST_CONVERSATION) {
        continue;
      }
      var my_loc = Tuple2<num, num>(person.location.x, person.location.y);
      var wanted_loc = person_to_desired_location[person];
      if(location_to_desiring_persons[my_loc] == null) {
        continue;
      }
      for(Person person2 in location_to_desiring_persons[my_loc]) {
        if(person == person2) {
          continue;
        }
        if(((person2.location.x == wanted_loc.item1) && (person2.location.y == wanted_loc.item2)) || (person_to_direction[person] == Direction.STAY)) {
          if(person2.state == PersonState.CONVERSING) {
            break;
          }
          if(person2.state == PersonState.POST_CONVERSATION) {
            break;
          }
          player.mana += start_conversation(person, person2);
        }
      }
    }

    var used_locations = HashSet<Tuple2<num, num>>();
    for(var person in persons) {
      used_locations.add(Tuple2<num, num>(person.location.x, person.location.y));
    }

    var empty_locations = [];
    for(num x = 0; x < map.width; x++) {
      for(num y = 0; y < map.height; y++) {
        if((is_walkable_arr[x][y]) && (!used_locations.contains(Tuple2<num, num>(x, y)))) {
          empty_locations.add(Tuple2<num, num>(x, y));
        }
      }
    }

    for(var ind = 0; ind < empty_locations.length; ind++) {
      var curr_location = empty_locations[ind];
      if(location_to_desiring_persons[curr_location] == null) {
        continue;
      }
      Person picked_person = location_to_desiring_persons[curr_location][0];
      for(var person in location_to_desiring_persons[curr_location]) {
        if(person_to_direction[person] == Direction.STAY) {
          picked_person = person;
        }
      }
      empty_locations.add(picked_person.location);
      picked_person.walk_in_direction(person_to_direction[picked_person]);
    }

    // Swap previously conversing pairs:
    for(var person in persons) {
      if(person.state != PersonState.POST_CONVERSATION) {
        continue;
      }
      if(person_to_direction[person] == Direction.STAY) {
        continue;
      }
      var my_loc = Tuple2<num, num>(person.location.x, person.location.y);
      var wanted_loc = person_to_desired_location[person];
      if(location_to_desiring_persons[my_loc] == null) {
        continue;
      }
      for(Person person2 in location_to_desiring_persons[my_loc]) {
        if(person2.state != PersonState.POST_CONVERSATION) {
          continue;
        }
        if((person2.location.x == wanted_loc.item1) && (person2.location.y == wanted_loc.item2)) {
          if(person.conversation_buddy == person2) {
            assert(person2.conversation_buddy == person);
            person.walk_in_direction(person_to_direction[person]);
            person2.walk_in_direction(person_to_direction[person2]);
          }
        }
      }
    }

    // Turn off 'post-conversers':
    for(var person in persons) {
      if(person.state == PersonState.POST_CONVERSATION) {
        person.state = PersonState.STAYING;
        person.update_sprite();
      }
    }
  }

  bool is_free_location(Location loc) { // Returns whether no one is planning to go to th at location
    for(Person person in persons) {
      if((person.next_location.x == loc.x) && (person.next_location.y == loc.y)) {
        return false;
      }
    }
    return true;
  }
  
  void update(num dt) {
    clock_progress += dt / CLOCK_TIME;
    for (Person p in persons)
      p.update(dt);
    player.update(dt);
    if (clock_progress >= 1.0) {
      do_routing();
      clock_progress = 0.0;
      check_win_condition();
    }
    if(state == WorldState.BOOTING) {
      tint_level -= dt * CLOCK_TIME * MAX_TINT / TINT_TIME;
      if(tint_level <= 0.0) {
        tint_level = 0.0;
        state = WorldState.ONGOING;
      }
    }
    if((state == WorldState.WIN_SCREEN) || (state == WorldState.LOSE_SCREEN)) {
      if(tint_level < MAX_TINT) {
        tint_level += dt * CLOCK_TIME * MAX_TINT / TINT_TIME;
        if (tint_level >= MAX_TINT) {
          tint_level = MAX_TINT;
          if(state == WorldState.WIN_SCREEN) {
            document.onKeyDown.listen((e) => {state = WorldState.WIN});
          }
          if(state == WorldState.LOSE_SCREEN) {
            document.onKeyDown.listen((e) => {state = WorldState.LOSE});
          }
        }
      }
    }
  }

  void draw_winlose_screen(CanvasRenderingContext2D ctx, ImageElement element) {
    num scale_bound1 = element.width / (TILE_SIZE * map.width * WINLOSE_SCREEN_MAX_RELATIVE_WIDTH * 1.0);
    num scale_bound2 = element.height / (TILE_SIZE * map.height * WINLOSE_SCREEN_MAX_RELATIVE_HEIGHT * 1.0);
    num scale = max(scale_bound1, scale_bound2);
    num actual_width = element.width / scale;
    num actual_height = element.height / scale;
    num center_x = TILE_SIZE * map.width / 2.0;
    num center_y = TILE_SIZE * map.height / 2.0;
    ctx.drawImageScaled(element, (center_x-(actual_width/2.0)).round(), (center_y-(actual_height/2.0)).round(),
        actual_width, actual_height);
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    map.draw(ctx);
    List<Tuple2<Drawable, Location>> objects = List<Tuple2<Drawable, Location>>();
    for (Person p in persons) {
      objects.add(Tuple2<Drawable, Location>(p, p.location));
    }
    for(Tuple2<Obstacle, Location> obstacle in obstacles) {
      objects.add(obstacle);
    }
    objects.sort((a, b) => compare_locs(a.item2, b.item2));
    for(var obj in objects) {
      obj.item1.draw(ctx, obj.item2);
    }
    player.draw(ctx);
    player.draw_mana(ctx);

    ctx.fillStyle = "rgb(0, 0, 0," + tint_level.toString() + ")";
    ctx.fillRect(0, 0, map.width * TILE_SIZE, map.height * TILE_SIZE);
    ctx.fillStyle = "rgb(0, 0, 0)";

    if(state == WorldState.LOSE_SCREEN) {
      if(tint_level == MAX_TINT) {
        draw_winlose_screen(ctx, level_lose_screen);
//        ctx.drawImageScaled(level_lose_screen, 0, 0, TILE_SIZE * map.width,
//            TILE_SIZE * map.height);
      }
    }
    if(state == WorldState.WIN_SCREEN) {
      if(tint_level == MAX_TINT) {
        draw_winlose_screen(ctx, win_screen);
      }
    }
  }

  void force_restart() {
    state = WorldState.LOSE;
  }

  void finish(bool fade_music) {
    if(fade_music) {
      if (music != null) {
        music.fade(0.6, 0, 3000);
      }
    }
  }

  void check_win_condition() {
    bool has_won = true;
    for(var person in persons) {
      if(person.belief <= 0) {
        has_won = false;
      }
    }
    if(has_won) {
      state = WorldState.WIN_SCREEN;
      return;
    }
    bool has_lost_for_lack_of_mana = true;
    if(player.mana >= SUGGESTION_MANA_USAGE) {
      has_lost_for_lack_of_mana = false;
    }
    for(var person in persons) {
      if(person.belief > 0) {
        has_lost_for_lack_of_mana = false;
      }
    }
    bool has_lost_for_negative_global_opinion = true;
    for(var person in persons) {
      if(person.belief >= 0) {
        has_lost_for_negative_global_opinion = false;
      }
    }
    if(has_lost_for_lack_of_mana || has_lost_for_negative_global_opinion) {
      state = WorldState.LOSE_SCREEN;
      document.onKeyDown.listen((e) => {state = WorldState.LOSE});
      return;
    }
  }
}

import 'dart:html';
import 'dart:math';
import 'utils.dart';
import 'tile.dart';
import 'map.dart';
import 'person.dart';
import 'level.dart';
import 'dart:collection';
import 'package:tuple/tuple.dart';
import 'player.dart';

class World {
  Map map;
  List<Person> persons;
  num clock_progress;
  Player player;
  World(Level level) {
    clock_progress = 0;
    player = Player(this);
    this.map = Map.fromString(
"""
rrrg
rgrg
rrrg
rrrg
gggg
"""
    );
    persons = [Person([Location(0, 0), Location(1, 2)]),
               Person([Location(2, 0), Location(1, 2)]),
               Person([Location(1, 3), Location(1, 2)])];
    do_routing();
  }
  
  Object closest_object_to(Location p) {
    num min_dist = 99999999999;
    Object result = null;
    for (Person person in persons) {
      num dist = Location.distance(person.location, p); // TODO: use interpolated location
      if (dist < min_dist) {
        min_dist = dist;
        result = person;
      }
    }
    return result;
  }

  void do_routing() {
    var person_to_direction = {};
    var location_to_interested_persons = {};
    for(var person in persons) {
      Direction dir = person.get_wanted_direction(map);
      person_to_direction[person] = dir;
      var wanted_loc = location_add(person.location, dir);
      var wanted_loc_tup = Tuple2<num, num>(wanted_loc.x, wanted_loc.y);
      var curr_list = location_to_interested_persons[wanted_loc_tup];
      if(curr_list == null) {
        curr_list = [];
      }
      curr_list.add(person);
      location_to_interested_persons[wanted_loc_tup] = curr_list;
    }

    var used_locations = HashSet<Tuple2<num, num>>();
    for(var person in persons) {
      used_locations.add(Tuple2<num, num>(person.location.x, person.location.y));
    }

    var empty_locations = [];
    for(num x = 0; x < map.width; x++) {
      for(num y = 0; y < map.height; y++) {
        if((map.tiles[x][y].is_walkable) && (!used_locations.contains(Tuple2<num, num>(x, y)))) {
          empty_locations.add(Tuple2<num, num>(x, y));
        }
      }
    }

    for(var ind = 0; ind < empty_locations.length; ind++) {
      var curr_location = empty_locations[ind];
      if(location_to_interested_persons[curr_location] == null) {
        continue;
      }
      Person picked_person = location_to_interested_persons[curr_location][0];
      for(var person in location_to_interested_persons[curr_location]) {
        if(person_to_direction[person] == Direction.STAY) {
          picked_person = person;
        }
      }
      empty_locations.add(picked_person.location);
      print("!!!");
      print(picked_person);
      print(person_to_direction[picked_person]);
      picked_person.walk_in_direction(person_to_direction[picked_person]);
    }
  }
  
  void update(num dt) {
    clock_progress += dt / CLOCK_TIME;
    for (Person p in persons)
      p.update(dt);
    player.update(dt);
    if (clock_progress >= 1.0) {
      print("HURRAH");
      do_routing();
      clock_progress = 0.0;
    }
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    map.draw(ctx);
    for (Person p in persons) {
      p.draw(ctx);
    }
    player.draw(ctx);
  }

}

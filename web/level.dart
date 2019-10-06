import 'package:tuple/tuple.dart';

import 'obstacle.dart';
import 'world.dart';
import 'worldmap.dart';
import 'person.dart';
import 'utils.dart';
import 'dart:collection';
import 'obstacle.dart';
import 'package:howler/howler.dart';

class Level {
  WorldMap map;
  List<Person> persons;
  List<Tuple2<Obstacle, Location> > obstacles;
  Howl music;
  num starting_mana;

  Level(WorldMap t_map, List<Person> t_persons, List<Tuple2<Obstacle, Location> > t_obstacles, num t_starting_mana, {Howl t_music = null}) {
    map = t_map;
    persons = t_persons;
    obstacles = t_obstacles;
    music = t_music;
    starting_mana = t_starting_mana;
    HashSet<Tuple2<num, num>> starting_points = HashSet<Tuple2<num, num>>();
    for(Person person in persons) {
      for(Tuple2<Location, num> waypoint_and_wait in person.waypoints_and_waits) {
        Location waypoint = waypoint_and_wait.item1;
        assert(verbosify(map.is_valid_location(waypoint), "(${waypoint.x}, ${waypoint.y}) not a valid location!"));
        assert(verbosify(map.tiles[waypoint.x][waypoint.y].is_walkable, "(${waypoint.x}, ${waypoint.y}) not a walkable location!"));
      }
      Tuple2<num, num> loc_tup = Tuple2<num, num>(person.waypoints_and_waits[0].item1.x, person.waypoints_and_waits[0].item1.y);
      assert(verbosify(!starting_points.contains(loc_tup), "Two persons starting at (${loc_tup.item1}, ${loc_tup.item2})!"));
      starting_points.add(loc_tup);
    }
    for(var obstacle_with_loc in obstacles) {
      for(num curr_x = obstacle_with_loc.item2.x - obstacle_with_loc.item1.occupy_dimensions.item1 + 1; curr_x <= obstacle_with_loc.item2.x; curr_x++) {
        for(num curr_y = obstacle_with_loc.item2.y - obstacle_with_loc.item1.occupy_dimensions.item2 + 1; curr_y <= obstacle_with_loc.item2.y; curr_y++) {
          Tuple2<num, num> loc_tup = Tuple2<num, num>(curr_x, curr_y);
          assert(verbosify(!starting_points.contains(loc_tup), "Double occupancy of tile (${loc_tup.item1}, ${loc_tup.item2})!"));
          starting_points.add(loc_tup);
        }
      }
    }
  }
}

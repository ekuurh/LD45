import 'package:tuple/tuple.dart';

import 'world.dart';
import 'worldmap.dart';
import 'person.dart';
import 'utils.dart';
import 'dart:collection';

class Level {
  WorldMap map;
  List<Person> persons;

  Level(WorldMap t_map, List<Person> t_persons) {
    map = t_map;
    persons = t_persons;
    HashSet<Tuple2<num, num>> starting_points = HashSet<Tuple2<num, num>>();
    for(Person person in persons) {
      for(Location waypoint in person.waypoints) {
        assert(verbosify(map.is_valid_location(waypoint), "(${waypoint.x}, ${waypoint.y}) not a valid location!"));
        assert(verbosify(map.tiles[waypoint.x][waypoint.y].is_walkable, "(${waypoint.x}, ${waypoint.y}) not a walkable location!"));
      }
      Tuple2<num, num> loc_tup = Tuple2<num, num>(person.waypoints[0].x, person.waypoints[0].y);
      assert(verbosify(!starting_points.contains(loc_tup), "Two persons starting at (${loc_tup.item1}, ${loc_tup.item2})!"));
      starting_points.add(loc_tup);
    }
  }
}

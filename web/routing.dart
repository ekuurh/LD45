import 'utils.dart';
import 'map.dart';
import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

num INFINITY = 9999999999;

List<Location> get_walkable_neighbors(Location loc, Map map) {
  List<Location> options = [];
  if(loc.x > 0) {
    options.add(Location(loc.x-1, loc.y));
  }
  if(loc.x < map.width - 1) {
    options.add(Location(loc.x+1, loc.y));
  }
  if(loc.y > 0) {
    options.add(Location(loc.x, loc.y-1));
  }
  if(loc.y < map.height - 1) {
    options.add(Location(loc.x, loc.y+1));
  }
  List<Location> res = [];
  for(num ind = 0; ind < options.length; ind++) {
    final curr = options[ind];
    if(map.tiles[curr.x][curr.y].is_walkable) {
      res.add(curr);
    }
  }
  return res;
}

RoutingResult how_to_get_to(Location from, Location to, Map map) {
  assert((0 <= from.x) && (from.x < map.width));
  assert((0 <= from.y) && (from.y < map.height));
  assert((0 <= to.x) && (to.x < map.width));
  assert((0 <= to.y) && (to.y < map.height));
  assert(map.tiles[from.x][from.y].is_walkable);
  assert(map.tiles[to.x][to.y].is_walkable);

  var distances = List.generate(map.width, (_) => new List(map.height));
  for(num x = 0; x < map.width; x++) {
    for(num y = 0; y < map.height; y++) {
      distances[x][y] = INFINITY;
    }
  }
  distances[to.x][to.y] = 0;

  var locations = PriorityQueue((p1, p2) => p1.item2 - p2.item2);
  locations.add(Tuple2<Location, num>(to, 0));
  while(locations.length > 0) {
    var curr = locations.removeFirst();
    print(curr);
    if(curr.item2 != distances[curr.item1.x][curr.item1.y]) {
      // Location already invalidated
      assert(curr.item2 > distances[curr.item1.x][curr.item1.y]);
      continue;
    }
    var neighbors = get_walkable_neighbors(curr.item1, map);
    for(num ind = 0; ind < neighbors.length; ind++) {
      var next = neighbors[ind];
      if(distances[next.x][next.y] > curr.item2 + 1) {
        distances[next.x][next.y] = curr.item2 + 1;
        locations.add(Tuple2<Location, num>(next, curr.item2 + 1));
      }
    }
  }
  if(distances[from.x][from.y] == INFINITY) {
    return RoutingResult.NAN;
  }
  var from_neighbors = get_walkable_neighbors(from, map);
  for(num ind = 0; ind < from_neighbors.length; ind++) {
    var curr = from_neighbors[ind];
    if(distances[curr.x][curr.y] < distances[from.x][from.y]) {
      if(curr.x < from.x) {
        return RoutingResult.LEFT;
      }
      if(curr.x > from.x) {
        return RoutingResult.RIGHT;
      }
      if(curr.y < from.y) {
        return RoutingResult.UP;
      }
      if(curr.y > from.y) {
        return RoutingResult.DOWN;
      }
      throw "WTF2";
    }
  }
  throw "WTF3";
}

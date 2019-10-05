import 'utils.dart';
import 'map.dart';
import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

num INFINITY = 9999999999;

List<Point> get_neighbors(Point loc, Map map) {
  List<Point> options;
  if(loc.x > 0) {
    options.add(Point(loc.x-1, loc.y));
  }
  if(loc.x < map.width - 1) {
    options.add(Point(loc.x+1, loc.y));
  }
  if(loc.y > 0) {
    options.add(Point(loc.x, loc.y-1));
  }
  if(loc.y < map.height - 1) {
    options.add(Point(loc.x, loc.y+1));
  }
  List<Point> res;
  return options.where((neighbor) => map.tiles[neighbor.x][neighbor.y].is_walkable);
}

Direction how_to_get_to(Point from, Point to, Map map) {
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
  locations.add(Tuple2<Point, num>(to, 0));
  while(locations.length > 0) {
    var curr = locations.removeFirst();
    if(curr.item1 != distances[curr.item0.x][curr.item0.y]) {
      // Point already invalidated
      assert(curr.item1 > distances[curr.item0.x][curr.item0.y]);
      continue;
    }
    var neighbors = get_neighbors(curr.item0, map);
    for(num ind = 0; ind < neighbors.length; ind++) {
      var next = neighbors[ind];
      if(distances[next.x][next.y] > curr.item1 + 1) {
        distances[next.x][next.y] = curr.item1 + 1;
        locations.add(Tuple2<Point, num>(next, curr.item1 + 1));
      }
    }
  }
  if(distances[from.x][from.y] == INFINITY) {
    throw "WTF1";
  }
  var from_neighbors = get_neighbors(from, map);
  for(num ind = 0; ind < from_neighbors.length; ind++) {
    var curr = from_neighbors[ind];
    if(distances[curr.x][curr.y] < distances[from.x][from.y]) {
      if(curr.x < from.x) {
        return Direction.LEFT;
      }
      if(curr.x > from.x) {
        return Direction.RIGHT;
      }
      if(curr.y < from.y) {
        return Direction.UP;
      }
      if(curr.y > from.y) {
        return Direction.DOWN;
      }
      throw "WTF2";
    }
  }
  throw "WTF3";
}

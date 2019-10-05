num TILE_SIZE = 16;
const num CLOCK_TIME = 1.0;

enum Direction {
  UP,
  DOWN,
  LEFT,
  RIGHT,
  STAY
}

enum RoutingResult {
  UP,
  DOWN,
  LEFT,
  RIGHT,
  NAN
}

Direction routing_result_to_direction(RoutingResult res) {
  assert(res != RoutingResult.NAN);
  if(res == RoutingResult.DOWN) {
    return Direction.DOWN;
  }
  if(res == RoutingResult.UP) {
    return Direction.UP;
  }
  if(res == RoutingResult.LEFT) {
    return Direction.LEFT;
  }
  if(res == RoutingResult.RIGHT) {
    return Direction.RIGHT;
  }
  throw "WTF4";
}

class Location {
  int x;
  int y;
  Location(this.x, this.y);
}

Location location_add(Location prev, Direction dir) {
  Location ret;
  switch(dir) {
    case Direction.DOWN:  {ret = Location(prev.x, prev.y+1);} break;
    case Direction.LEFT:  {ret = Location(prev.x-1, prev.y);} break;
    case Direction.UP:    {ret = Location(prev.x, prev.y-1);} break;
    case Direction.RIGHT: {ret = Location(prev.x+1, prev.y);} break;
    case Direction.STAY:  {ret = Location(prev.x,   prev.y);} break;
  }
  return ret;
}

num interpolate(num start, num end, num progress) {
  return start * (1 - progress) + end * progress;
}
import 'dart:html';
import 'dart:math';

num TILE_SIZE = 16;
const num CLOCK_TIME = 0.2;
ImageElement level_win_screen = ImageElement(src: "resources/images/level_win_screen.png");
ImageElement level_lose_screen = ImageElement(src: "resources/images/level_lose_screen.png");
bool is_muted=false;

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
  num x;
  num y;
  Location(this.x, this.y);
  
  static num distance(Location p1, Location p2) {
    return pow(pow(p1.x-p2.x, 2) + pow(p1.y-p2.y, 2), 0.5);
  }
}

num compare_locs(Location first, Location second) {
  if(first.y < second.y) {
    return -1;
  }
  if(first.y > second.y) {
    return 1;
  }
  if(first.x < second.x) {
    return -1;
  }
  if(first.x > second.x) {
    return 1;
  }
  return 0;
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

num clamp(num x, num min, num max) {
  if (x < min)
    return min;
    
  if (x > max)
    return max;
    
  return x;
}

bool verbosify(bool condition, String message) {
  if(!condition) {
    print(message);
  }
  return condition;
}

class Drawable {
  void draw(CanvasRenderingContext2D ctx, Location loc) {}
}

int print_and_fail(String message) {
  print(message);
  assert(false);
}

int verbose_parse_string(String input, String error_message) {
  return int.parse(input, onError: (jnk) => print_and_fail(error_message));
}
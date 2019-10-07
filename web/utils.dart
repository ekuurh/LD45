import 'dart:html';
import 'dart:math' as math;
import 'package:tuple/tuple.dart';

num TILE_SIZE = 16;
const num REGULAR_CLOCK_TIME = 0.5;
const num FAST_CLOCK_TIME = 0.15;
num CLOCK_TIME = REGULAR_CLOCK_TIME;
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

num abs(num x) {
  if(x < 0) {
    return -x;
  }
  return x;
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
    return math.pow(math.pow(p1.x-p2.x, 2) + math.pow(p1.y-p2.y, 2), 0.5);
  }
  
  Location rotate(num angle) {
    num sina = math.sin(angle);
    num cosa = math.cos(angle);
    return Location(cosa * x + sina * y, - sina * x + cosa * y);
  }

  Location integer_rotate(num num_spins) {
    num_spins %= 4;
    if(num_spins == 0) return Location(x, y);
    if(num_spins == 1) return Location(y, -x);
    if(num_spins == 2) return Location(-x, -y);
    if(num_spins == 3) return Location(-y, x);
    assert(verbosify(false, "weird... there are ${num_spins} spins."));
  }

  Tuple2<num, num> to_tuple() {
    return Tuple2<num, num>(x, y);
  }

  Tuple2<num, num> to_abs_tuple() {
    return Tuple2<num, num>(abs(x), abs(y));
  }

  Location.from_tuple(Tuple2<num, num> tup) {
    x = tup.item1;
    y = tup.item2;
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

List<T> pick_elements_from_list<T>(List<T> arr, num amount) {
  assert(verbosify(arr.length >= amount, "List ${arr} smaller than ${amount} elements"));
  List<T> arr2 = arr.sublist(0);
  arr2.shuffle();
  return arr2.sublist(0, amount);
}

List<T> generate_random_list_from_pool<T>(List<T> pool, num amount) {
  List<T> ret = [];
  for(var ind = 0; ind < amount; ind++) {
    ret.add(pick_elements_from_list(pool, 1).first);
  }
  return ret;
}
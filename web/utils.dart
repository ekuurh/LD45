import 'dart:math';

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

class Location {
  num x;
  num y;
  Location(this.x, this.y);
  
  static num distance(Location p1, Location p2) {
    return pow(pow(p1.x-p2.x, 2) + pow(p1.y-p2.y, 2), 0.5);
  }
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
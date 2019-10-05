num TILE_SIZE = 16;

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
  int x;
  int y;
  Location(this.x, this.y);
}

num interpolate(num start, num end, num progress) {
  return start * (1 - progress) + end * progress;
}
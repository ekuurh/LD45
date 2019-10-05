num TILE_SIZE = 16;
const num CLOCK_TIME = 1.0;

enum Direction {
  UP,
  DOWN,
  LEFT,
  RIGHT
}

class Point {
  int x;
  int y;
  Point(this.x, this.y);
}

num interpolate(num start, num end, num progress) {
  return start * (1 - progress) + end * progress;
}
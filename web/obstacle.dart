import 'dart:html';
import 'package:tuple/tuple.dart';
import 'player.dart';
import 'utils.dart';

class Obstacle {
  ImageElement img;
  Tuple2<num, num> dimensions; // anchored by bottom-right point
  bool is_actionable;

  Obstacle(this.img, this.dimensions, this.is_actionable);
  void draw(CanvasRenderingContext2D ctx, Location loc) {
    ctx.drawImageScaled(img, loc.x * TILE_SIZE, loc.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
  }

  void do_action(Player player) {}
}

class StaticObstacle extends Obstacle {
  StaticObstacle(ImageElement img, Tuple2<num, num> dimensions) : super(img, dimensions, false);
}

StaticObstacle make_house() {
  return StaticObstacle(ImageElement(src: 'resources/house_large.bmp'), Tuple2<num, num>(2, 2));
}

import 'dart:html';
import 'package:tuple/tuple.dart';
import 'player.dart';
import 'utils.dart';

class Obstacle extends Drawable {
  ImageElement img;
  Tuple2<num, num> dimensions; // anchored by bottom-right point
  bool is_actionable;

  Obstacle(this.img, this.dimensions, this.is_actionable);
  void draw(CanvasRenderingContext2D ctx, Location loc) {
    ctx.drawImageScaled(img, (loc.x - dimensions.item1 + 1) * TILE_SIZE, (loc.y - dimensions.item2 + 1) * TILE_SIZE,
        dimensions.item1 * TILE_SIZE, dimensions.item2 * TILE_SIZE);
  }

  Tuple2<StaticObstacle, Location> do_action(Player player, Location my_loc) {}
}

class StaticObstacle extends Obstacle {
  StaticObstacle(ImageElement img, Tuple2<num, num> dimensions) : super(img, dimensions, false);
}

class FallingObstacle extends Obstacle {
  FallingObstacle(ImageElement img, Tuple2<num, num> dimensions) : super(img, dimensions, false);
  Tuple2<StaticObstacle, Location> do_action(Player player, Location my_loc) {
    print("poof.");
    if(player.x > my_loc.x) {
      // anchor by bottom-right
      return Tuple2(StaticObstacle(img, Tuple2<num, num>(dimensions.item2, dimensions.item1)), my_loc);
    }
    // anchor by bottom-left
    Location new_loc = Location(my_loc.x - dimensions.item1 + dimensions.item2, my_loc.y);
    return Tuple2(StaticObstacle(img, Tuple2<num, num>(dimensions.item2, dimensions.item1)), new_loc);
  }
}

StaticObstacle make_house() {
  return StaticObstacle(ImageElement(src: 'resources/house_large.png'), Tuple2<num, num>(2, 2));
}

StaticObstacle make_tree1() {
  return StaticObstacle(ImageElement(src: 'resources/tree.bmp'), Tuple2<num, num>(1, 1));
}

FallingObstacle make_tree2() {
  return FallingObstacle(ImageElement(src: 'resources/tree2.bmp'), Tuple2<num, num>(1, 2));
}

StaticObstacle make_bush1() {
  return StaticObstacle(ImageElement(src: 'resources/bush.bmp'), Tuple2<num, num>(1, 1));
}

StaticObstacle make_bush2() {
  return StaticObstacle(ImageElement(src: 'resources/bush2.bmp'), Tuple2<num, num>(1, 1));
}

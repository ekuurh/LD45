import 'dart:html';
import 'package:tuple/tuple.dart';
import 'player.dart';
import 'utils.dart';

class Obstacle extends Drawable {
  ImageElement img;
  Tuple2<num, num> draw_dimensions; // anchored by bottom-right point
  Tuple2<num, num> occupy_dimensions; // anchored by bottom-right point
  bool is_actionable;

  Obstacle(this.img, this.draw_dimensions, this.occupy_dimensions, this.is_actionable);
  void draw(CanvasRenderingContext2D ctx, Location loc) {
    ctx.drawImageScaled(img, (loc.x - draw_dimensions.item1 + 1) * TILE_SIZE, (loc.y - draw_dimensions.item2 + 1) * TILE_SIZE,
        draw_dimensions.item1 * TILE_SIZE, draw_dimensions.item2 * TILE_SIZE);
  }

  Tuple2<StaticObstacle, Location> do_action(Player player, Location my_loc) {}
}

class StaticObstacle extends Obstacle {
  StaticObstacle(ImageElement img, Tuple2<num, num> draw_dimensions, Tuple2<num, num> occupy_dimensions) : super(img, draw_dimensions, occupy_dimensions, false);
}

class FallingObstacle extends Obstacle {
  FallingObstacle(ImageElement img, Tuple2<num, num> draw_dimensions, Tuple2<num, num> occupy_dimensions) : super(img, draw_dimensions, occupy_dimensions, false);
  Tuple2<StaticObstacle, Location> do_action(Player player, Location my_loc) {
    print("poof.");
    Tuple2<num, num> new_dimension_tup = Tuple2<num, num>(draw_dimensions.item2, draw_dimensions.item1);
    if(player.x > my_loc.x - (draw_dimensions.item1 - 1) / 2) {
      // anchor by bottom-right
      return Tuple2(StaticObstacle(img, new_dimension_tup, new_dimension_tup), my_loc);
    }
    // anchor by bottom-left
    Location new_loc = Location(my_loc.x - draw_dimensions.item1 + draw_dimensions.item2, my_loc.y);
    return Tuple2(StaticObstacle(img, new_dimension_tup, new_dimension_tup), new_loc);
  }
}

StaticObstacle make_house() {
  return StaticObstacle(ImageElement(src: 'resources/images/house_large.png'), Tuple2<num, num>(2, 2), Tuple2<num, num>(2, 1));
}

StaticObstacle make_tree1() {
  return StaticObstacle(ImageElement(src: 'resources/images/tree1_large.png'), Tuple2<num, num>(2, 2), Tuple2<num, num>(2, 1));
}

FallingObstacle make_tree2() {
  return FallingObstacle(ImageElement(src: 'resources/images/tree2_large.png'), Tuple2<num, num>(1, 2), Tuple2<num, num>(1, 1));
}

StaticObstacle make_bush1() {
  return StaticObstacle(ImageElement(src: 'resources/images/bush_large.png'), Tuple2<num, num>(2, 2), Tuple2<num, num>(2, 1));
}

StaticObstacle make_bush2() {
  return StaticObstacle(ImageElement(src: 'resources/images/bush2.bmp'), Tuple2<num, num>(1, 1), Tuple2<num, num>(1, 1));
}

List<Tuple2<Obstacle, Location>> obstacles_from_string(String s) {
  int i;
  int line, col;
  List<Tuple2<Obstacle, Location>> ret = List<Tuple2<Obstacle, Location>>();
  line = 0;
  col = 0;
  for (i = 0; i < s.length; i++) {
    String ch = s[i];
    Obstacle current = null;
    switch (ch) {
      case "H":
// Road
        current = make_house();
        break;
      case "t":
        current = make_tree1();
        break;
      case "T":
        current = make_tree2();
        break;
      case "b":
        current = make_bush1();
        break;
      case "B":
        current = make_bush2();
        break;
      case "-":
        break;
      case "\n":
        {if (col != 0) {
// Ignore lines with no tiles
          line++;
          col = -1;
        }} break;
    }

    if (current != null) {
      ret.add(Tuple2<Obstacle, Location>(current, Location(col, line)));
    }
    col++;
  }
  return ret;
}

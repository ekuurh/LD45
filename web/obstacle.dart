import 'dart:html';
import 'package:tuple/tuple.dart';
import 'player.dart';
import 'resources/resources.dart';
import 'utils.dart';
import 'dart:math' as math;

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

  Tuple3<bool, Obstacle, Location> do_action(Player player, Location my_loc) {}

  void update(num dt) {}
}

class StaticObstacle extends Obstacle {
  StaticObstacle(ImageElement img, Tuple2<num, num> draw_dimensions, Tuple2<num, num> occupy_dimensions) : super(img, draw_dimensions, occupy_dimensions, false);
}

class RotatingObstacle extends Obstacle {
  num angle;
  num rotation_speed;
  num end_angle;
  bool done_rotating;
  RotatingObstacle(ImageElement img, Tuple2<num, num> draw_dimensions, Tuple2<num, num> occupy_dimensions,
                   num start_angle, num t_end_angle, {num rotation_time = 2.0}) : super(img, draw_dimensions, occupy_dimensions, false) {
    angle = start_angle;
    end_angle = t_end_angle;
    rotation_speed = (end_angle - start_angle)/rotation_time;
    done_rotating = false;
  }

  @override
  void draw(CanvasRenderingContext2D ctx, Location loc) {
    print(angle);
    ctx.rotate(-angle);
    Location anchored_loc = Location(loc.x - draw_dimensions.item1 + 1, loc.y - draw_dimensions.item2 + 1);
    Location rotated_anchored_loc = anchored_loc.rotate(-angle);
    Location rotated_loc = Location(rotated_anchored_loc.x + draw_dimensions.item1 - 1, rotated_anchored_loc.y + draw_dimensions.item2 - 1);
    super.draw(ctx, rotated_loc);
    ctx.rotate(angle);
  }

  @override
  void update(num dt) {
    super.update(dt);
    if(done_rotating) return;

    num added_angle = dt * rotation_speed / CLOCK_TIME;
    angle += added_angle;
    if(rotation_speed < 0) {
      if(angle < end_angle) {
        angle = end_angle;
        done_rotating = true;
      }
    }

    if(rotation_speed > 0) {
      if(angle > end_angle) {
        angle = end_angle;
        done_rotating = true;
      }
    }
  }
}

class FallingObstacle extends Obstacle {
  FallingObstacle(ImageElement img, Tuple2<num, num> draw_dimensions, Tuple2<num, num> occupy_dimensions) : super(img, draw_dimensions, occupy_dimensions, false);
  Tuple3<bool, Obstacle, Location> do_action(Player player, Location my_loc) {
    Tuple2<Obstacle, Location> ret;
    Tuple2<num, num> new_dimension_tup = Tuple2<num, num>(draw_dimensions.item2, draw_dimensions.item1);
    if(player.x > my_loc.x - (draw_dimensions.item1 - 1) / 2) {
      // anchor by bottom-right
      ret = Tuple2(RotatingObstacle(img, new_dimension_tup, new_dimension_tup, -math.pi/2, 0), my_loc);
    }
    else {
      // anchor by bottom-left
      Location new_loc = Location(
          my_loc.x - draw_dimensions.item1 + draw_dimensions.item2, my_loc.y);
      ret = Tuple2(
          RotatingObstacle(img, new_dimension_tup, new_dimension_tup, math.pi/2, 0),
          new_loc);
    }
    for(num i = 1-ret.item1.occupy_dimensions.item1; i <= 1; i++) {
      for(num j = 1-ret.item1.occupy_dimensions.item2; j <= 1; j++) {
        if(!player.world.is_free_location(Location(ret.item2.x + i, ret.item2.y + j))) {
          return Tuple3<bool, Obstacle, Location>(false, null, null);
        }
      }
    }
    return Tuple3<bool, Obstacle, Location>(true, ret.item1, ret.item2);
  }
}

StaticObstacle make_house() {
  return StaticObstacle(house_large_image, Tuple2<num, num>(2, 2), Tuple2<num, num>(2, 1));
}

StaticObstacle make_tree1() {
  return StaticObstacle(tree1_large_image, Tuple2<num, num>(2, 2), Tuple2<num, num>(2, 1));
}

FallingObstacle make_tree2() {
  return FallingObstacle(tree2_large_image, Tuple2<num, num>(1, 2), Tuple2<num, num>(1, 1));
}

StaticObstacle make_bush1() {
  return StaticObstacle(bush_large_image, Tuple2<num, num>(2, 2), Tuple2<num, num>(2, 1));
}

StaticObstacle make_bush2() {
  return StaticObstacle(bush2_image, Tuple2<num, num>(1, 1), Tuple2<num, num>(1, 1));
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
      case " ":
        col -= 1;
        break;
      default:
        {
          print("Obstacle parsing error - unrecognized character '${ch}'!");
          assert(false);
        } break;
    }

    if (current != null) {
      ret.add(Tuple2<Obstacle, Location>(current, Location(col, line)));
    }
    col++;
  }
  return ret;
}

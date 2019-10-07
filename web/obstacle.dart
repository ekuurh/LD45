import 'dart:html';
import 'package:tuple/tuple.dart';
import 'audio.dart';
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
  num starting_angle;
  num angle;
  num end_angle;
  num num_spins;
  bool done_rotating;
  num tot_time;
  num rotation_time;
  Location anchor;
  RotatingObstacle(ImageElement img, Tuple2<num, num> t_draw_dimensions, Tuple2<num, num> t_occupy_dimensions,
                   num t_num_spins, {num t_rotation_time = 2.0, Location t_anchor = null}) :
        super(img, Location.from_tuple(t_draw_dimensions).integer_rotate(t_num_spins).to_abs_tuple(),
          Location.from_tuple(t_occupy_dimensions).integer_rotate(t_num_spins).to_abs_tuple(), false) {
    num_spins = t_num_spins;
    angle = - num_spins * math.pi/2;
    starting_angle = angle;
    end_angle = 0;
    tot_time = 0;
    done_rotating = false;
    rotation_time = t_rotation_time;
    if(t_anchor == null) {
      if(num_spins%2 == 0) {
        anchor = Location(draw_dimensions.item1/2.0, draw_dimensions.item2/2.0);
      }
      else  if (num_spins%4 == 1){
        if(draw_dimensions.item1 >= draw_dimensions.item2) {
          anchor = Location(-draw_dimensions.item2/2.0 + 1, 1 - draw_dimensions.item2/2.0);
        }
        else {
          anchor = Location(-draw_dimensions.item1/2.0 + 1, 1 - draw_dimensions.item1/2.0);
        }
      }
      else {
        assert(verbosify(num_spins%4 == 3, "WTF"));
        if(draw_dimensions.item1 >= draw_dimensions.item2) {
          anchor = Location(-draw_dimensions.item1 + 1 + draw_dimensions.item2/2.0, -draw_dimensions.item2/2.0 + 1);
        }
        else {
          anchor = Location(-draw_dimensions.item1/2.0 + 1, 1 - draw_dimensions.item1/2.0);
        }
      }
    }
    else {
      anchor = t_anchor;
    }
  }

  @override
  void draw(CanvasRenderingContext2D ctx, Location loc) {
//    print(angle);
    ctx.rotate(-angle);
    Location rotated_anchor = anchor.rotate(-angle);
    Location rotated_unanchored_loc = loc.rotate(-angle);
    Location rotated_loc = Location(rotated_unanchored_loc.x + rotated_anchor.x - anchor.x, rotated_unanchored_loc.y + rotated_anchor.y - anchor.y);
    super.draw(ctx, rotated_loc);
    ctx.rotate(angle);
  }

  @override
  void update(num dt) {
    super.update(dt);
    if(done_rotating) return;

    tot_time += dt / CLOCK_TIME;

    angle = tot_time * tot_time;

    if(tot_time >= rotation_time) {
      tot_time = rotation_time;
      get_tree_fall_sound().play();
      angle = end_angle;
      done_rotating = true;
    }
    num move_percentage = math.pow(tot_time / rotation_time, 2);
    angle = interpolate(starting_angle, end_angle, move_percentage);
  }
}

class FallingObstacle extends Obstacle {
  List<ImageElement> images;
  FallingObstacle(List<ImageElement> t_images, Tuple2<num, num> draw_dimensions, Tuple2<num, num> occupy_dimensions) : super(t_images[0], draw_dimensions, occupy_dimensions, false) {
    images = t_images;
  }
  Tuple3<bool, Obstacle, Location> do_action(Player player, Location my_loc) {
    Tuple2<Obstacle, Location> ret;
//    Tuple2<num, num> new_dimension_tup = Tuple2<num, num>(draw_dimensions.item2, draw_dimensions.item1);
    if(player.x > my_loc.x - (draw_dimensions.item1 - 1) / 2) {
      // anchor by bottom-right
      ret = Tuple2(RotatingObstacle(images[1], draw_dimensions, draw_dimensions, 1), my_loc);
    }
    else {
      // anchor by bottom-left
      Location new_loc = Location(
          my_loc.x - draw_dimensions.item1 + draw_dimensions.item2, my_loc.y);
      ret = Tuple2(
          RotatingObstacle(images[2], draw_dimensions, draw_dimensions, -1),
          new_loc);
    }
    for(num i = 1-ret.item1.occupy_dimensions.item1; i <= 1; i++) {
      for(num j = 1-ret.item1.occupy_dimensions.item2; j <= 1; j++) {
        Location loc = Location(ret.item2.x + i, ret.item2.y + j);
        if(!player.world.map.is_valid_location(loc)) {
          return Tuple3<bool, Obstacle, Location>(false, null, null);
        }
        if(!player.world.is_free_location(loc)) {
          return Tuple3<bool, Obstacle, Location>(false, null, null);
        }
      }
    }
    print([[my_loc.x, my_loc.y], [ret.item2.x, ret.item2.y]]);
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
  return FallingObstacle([tree2_large_image, tree2_large_left_image, tree2_large_right_image], Tuple2<num, num>(1, 2), Tuple2<num, num>(1, 1));
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

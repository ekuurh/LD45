import 'dart:html';
import 'dart:math';
import 'utils.dart';
import 'tile.dart';
import 'map.dart';
import 'person.dart';

class World {
  Map map;
  List<Person> persons;
  num clock_progress;
  World() {
    clock_progress = 0;
    this.map = Map([[make_blue_tile(), make_red_tile()], [make_red_tile(), make_blue_tile()]]);
    List<Location> waypoints = [Location(0,0), Location(1,0), Location(1,1), Location(0,1)];
    persons = [Person(waypoints), Person(waypoints)];
    do_routing();
  }
  
  void do_routing() {
    for (Person p in persons) {
      p.walk_in_direction(Direction.RIGHT);
    }
  }
  
  void update(num dt) {
    clock_progress += dt / CLOCK_TIME;
    if (clock_progress >= 1.0) {
      do_routing();
      clock_progress = 0.0;
    }
    for (Person p in persons)
      p.update(dt);
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    map.draw(ctx);
    for (Person p in persons) {
      p.draw(ctx);
    }
  }

}

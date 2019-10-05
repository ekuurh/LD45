import 'dart:html';
import 'dart:math';
import 'utils.dart';
import 'tile.dart';
import 'map.dart';
import 'person.dart';

class World {
  Map map;
  List<Person> persons;
  World() {
    this.map = Map([[make_blue_tile(), make_red_tile()], [make_red_tile(), make_blue_tile()]]);
    persons = [Person(), Person()];
  }
  
  void update(num dt) {
    for (Person p in persons)
      p.update(dt);
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    map.draw(ctx);
    for (Person p in persons) {
      p.draw(ctx);
    }
  }
//  Map world = new Map([[make_blue_tile(), make_red_tile()], [make_red_tile(), make_blue_tile()]]);
}

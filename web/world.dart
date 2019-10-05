import 'dart:html';
import 'dart:math';
import 'utils.dart';
import 'tile.dart';
import 'map.dart';
import 'person.dart';
import 'level.dart';

const num PLAYER_SPEED = 2.0;

class Player {
  num speed_x, speed_y;
  num x, y;
  Player() {
    speed_x = 0;
    speed_y = 0;
    x = 1;
    y = 1;
  }
  
  void handle_keydown(KeyboardEvent e) {
    switch (e.key) {
      case "ArrowRight":
        speed_x = 1;
        break;
      case "ArrowLeft":
        speed_x = -1;
    }
  }
  void handle_keyup(KeyboardEvent e) {
    switch (e.key) {
      case "ArrowRight":
      case "ArrowLeft":
        speed_x = 0;
    }
  }
  
  void update(num dt) {
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    ctx.fillStyle = "#ffff00";
    ctx.fillRect((x + 0.1) * TILE_SIZE, (y + 0.1) * TILE_SIZE, TILE_SIZE * 0.8, TILE_SIZE * 0.8);
  }
}

class World {
  Map map;
  List<Person> persons;
  num clock_progress;
  Player player;
  World(Level level) {
    clock_progress = 0;
    player = Player();
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
    player.draw(ctx);
  }

}

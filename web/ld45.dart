import 'dart:html';
import 'dart:math';
import 'dynamic_sprite.dart';
import 'person.dart';
import 'resources/resources.dart';
import 'tile.dart';
import 'world.dart';
import 'worldmap.dart';
import 'routing.dart';
import 'utils.dart';
import 'level.dart';
import 'content.dart';
import 'audio.dart';
import 'package:howler/howler.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;
bool in_starting_screen;
var main_menu_music = get_main_menu_music();

void op_screen_handle_keydown(KeyboardEvent e) {
  if(!in_starting_screen) {
    return;
  }
  if((e.key == 'm') || (e.key == 'M')) {
    is_muted = !is_muted;
    main_menu_music.mute(is_muted);
  }
  else {
    in_starting_screen = false;
  }
}

void show_starting_screen(CanvasRenderingContext2D ctx) async {
//  var main_menu_music = get_main_menu_music();
  main_menu_music.play(); // Play sound.

//  document.onKeyDown.listen((e) => {in_starting_screen = false});
  document.onKeyDown.listen(op_screen_handle_keydown);
  in_starting_screen = true;

  while (in_starting_screen) {
    await window.animationFrame;
    ctx.drawImageScaled(op_screen_image, 0, 0, canvas.width, canvas.height);
  }

  main_menu_music.fade(0.6, 0.0, 1000);
}

void show_ending_screen(CanvasRenderingContext2D ctx) async {

  while (true) {
    await window.animationFrame;
    ctx.drawImageScaled(end_screen_image, 0, 0, canvas.width, canvas.height);
  }
}

CanvasElement adjust_canvas_and_tile_size(World world, CanvasElement canvas, var body) {
  TILE_SIZE = (canvas.width / max(world.map.width, world.map.height)).round();
  canvas.width = TILE_SIZE * world.map.width;
  canvas.height = TILE_SIZE * world.map.height;

  num canvas_style_width = body.clientHeight / world.map.height * world.map.width;
  canvas.style.width = '${canvas_style_width}px';
  return canvas;
}

void main() async {
  canvas = querySelector('#canvas');
  var body = querySelector('body');
  ctx = canvas.getContext('2d');

  World world;

  make_person_sprites();
  
  await show_starting_screen(ctx);

  num prevTime = await window.animationFrame;
  var level_ind = 0;
  bool just_lost = false;
  while(level_ind < all_levels.length) {
    world = World(all_levels[level_ind], !just_lost);
    canvas = adjust_canvas_and_tile_size(world, canvas, body);
    document.onKeyDown.listen(world.player.handle_keydown);
    document.onKeyUp.listen(world.player.handle_keyup);
    while (true) {

      num time = await window.animationFrame;
      num dt = (time - prevTime) / 1000.0; // In seconds
      prevTime = time;

      world.update(dt);
      world.draw(ctx);
      if (world.state == WorldState.LOSE) {
        print("YOU LOSE!");
        world.finish(false);
        just_lost = true;
        break;
      }
      if (world.state == WorldState.WIN) {
        print("YOU WIN!");
        world.finish(true);
        just_lost = false;
        level_ind += 1;
        break;
      }
    }
  }
  print("you beat all the levels!");
  show_ending_screen(ctx);
}
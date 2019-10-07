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

const num OPENING_SCROLL_TIME = 4.0;
const num OPENING_SCROLL_SPEED = 200.0;

const num OPENING_TEXT_TINT_TIME = 3.0;
const num OPENING_TEXT_STAY_TIME = 7.0;

CanvasElement canvas;
CanvasRenderingContext2D ctx;
bool waiting_for_click_at_start;
bool in_intro_screen;
var main_menu_music = get_main_menu_music();

void draw_image_x_scaled(CanvasRenderingContext2D ctx, ImageElement element, var base_y) async {
  var scale = element.width / canvas.width;
  ctx.drawImageScaled(op_screen_image, 0, base_y, element.width / scale, element.height / scale);
}

void op_screen_handle_keydown(KeyboardEvent e) {
  if(!in_intro_screen) {
    return;
  }
  if((e.key == 'm') || (e.key == 'M')) {
    is_muted = !is_muted;
    main_menu_music.mute(is_muted);
  }
  else if (waiting_for_click_at_start){
    waiting_for_click_at_start = false;
  }
}

void show_starting_screen(CanvasRenderingContext2D ctx) async {
//  var main_menu_music = get_main_menu_music();

//  document.onKeyDown.listen((e) => {in_starting_screen = false});
  document.onKeyDown.listen(op_screen_handle_keydown);
  waiting_for_click_at_start = true;
  in_intro_screen = true;

  await op_screen_image.onLoad.first;

  while (waiting_for_click_at_start) {
    await window.animationFrame;
    draw_image_x_scaled(ctx, op_screen_image, 0);
//    ctx.drawImageScaled(op_screen_image, 0, 0, canvas.width, canvas.height);
  }

  main_menu_music.play();

  num op_screen_y = 0;
  num startTime = await window.animationFrame;
  num time = startTime;
  while (time - startTime < OPENING_SCROLL_TIME * 1000) {
    time = await window.animationFrame;
    num tot = (time - startTime) / 1000.0; // In seconds

    op_screen_y = -tot*tot*OPENING_SCROLL_SPEED;
    draw_image_x_scaled(ctx, op_screen_image, op_screen_y);
  }

  startTime = await window.animationFrame;
  while (time - startTime < (OPENING_TEXT_TINT_TIME + OPENING_TEXT_STAY_TIME) * 1000) {
    time = await window.animationFrame;
    num tot = (time - startTime) / 1000.0; // In seconds
    
    num tint_level = 1 - min(tot / OPENING_TEXT_TINT_TIME, 1);

    ctx.drawImageScaled(intro_image, 0, 0, canvas.width, canvas.height);

    ctx.fillStyle = "rgb(0, 0, 0," + tint_level.toString() + ")";
    ctx.fillRect(0, 0, canvas.width, canvas.width * TILE_SIZE);
    ctx.fillStyle = "rgb(0, 0, 0)";
  }

  in_intro_screen = false;
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

  List to_loads = [level_lose_screen.onLoad.first];
  for(ImageElement element in level_win_screens) {
    to_loads.add(element.onLoad.first);
  }
  await to_loads;

  World world;

  make_person_sprites();
  make_all_persona_sounds();
  
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
        world.finish(false);
        just_lost = true;
        break;
      }
      if (world.state == WorldState.WIN) {
        world.finish(true);
        just_lost = false;
        level_ind += 1;
        break;
      }
    }
  }
  show_ending_screen(ctx);
}
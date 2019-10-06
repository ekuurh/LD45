import 'dart:html';
import 'package:tuple/tuple.dart';

import 'resources/resources.dart';
import 'utils.dart';

class DynamicSprite extends Drawable{
  List<List<ImageElement> > frames;
  Location dimensions;
  Location anchor;
  num framerate;

  num _time_until_swap;
  num _curr_frame;

  DynamicSprite(List<List<ImageElement>> t_frames, Location t_dimensions, {Location t_anchor = null, num t_framerate=4}) {
    frames = t_frames;
    dimensions = t_dimensions;
    framerate = t_framerate;
    _curr_frame = 0;
    _time_until_swap = 1.0/framerate;
    if(t_anchor == null) {
      anchor = Location(1 - dimensions.x, 1 - dimensions.y);
    }
    else {
      anchor = t_anchor;
    }
  }

  void draw(CanvasRenderingContext2D ctx, Location loc) {
    for(ImageElement frame in frames[_curr_frame]) {
      ctx.drawImageScaled(
          frame, (loc.x + anchor.x) * TILE_SIZE,
          (loc.y + anchor.y) * TILE_SIZE,
          dimensions.x * TILE_SIZE, dimensions.y * TILE_SIZE);
    }
  }

  void update(num dt) {
    _time_until_swap -= dt;
    if(_time_until_swap <= 0.0) {
      _time_until_swap = 1.0/framerate;
      _curr_frame = (_curr_frame + 1) % frames.length;
    }
  }
}

DynamicSprite get_person_sprite(bool is_walking, bool is_possessed, num belief) {
  return person_sprites[Tuple3<bool, bool, num>(is_walking, is_possessed, belief)];
}

void make_person_sprites() {
  String idle_possession_filepath = 'resources/images/possess_idle.png';
  String step1_possession_filepath = 'resources/images/possess_step1.png';
  String step2_possession_filepath = 'resources/images/possess_step2.png';

  person_sprites = {};

  for (var amount_possessed = -2; amount_possessed <= 2; amount_possessed++) {
    String filename_suffix;
    if(amount_possessed == -2) filename_suffix = "0";
    if(amount_possessed == -1) filename_suffix = "20";
    if(amount_possessed == 0) filename_suffix = "40";
    if(amount_possessed == 1) filename_suffix = "80";
    if(amount_possessed == 2) filename_suffix = "100";

    String path = 'resources/images/idle_' + filename_suffix + '.png';
    person_sprites[Tuple3<bool, bool, num>(false, false, amount_possessed)] = DynamicSprite([[ImageElement(src: path)]], Location(1, 1));
    person_sprites[Tuple3<bool, bool, num>(false, true, amount_possessed)] = DynamicSprite([[ImageElement(src: path), ImageElement(src: idle_possession_filepath)]], Location(1, 1));

    String path1 = 'resources/images/step1_' + filename_suffix + '.png';
    String path2 = 'resources/images/step2_' + filename_suffix + '.png';
    person_sprites[Tuple3<bool, bool, num>(true, false, amount_possessed)] = DynamicSprite([[ImageElement(src: path1)], [ImageElement(src: path2)]], Location(1, 1));
    person_sprites[Tuple3<bool, bool, num>(true, true, amount_possessed)] = DynamicSprite(
        [[ImageElement(src: path1), ImageElement(src: step1_possession_filepath)], [ImageElement(src: path2), ImageElement(src: step2_possession_filepath)]], Location(1, 1));
  }
}

Map<Tuple3<bool, bool, num>, DynamicSprite> person_sprites; // (is_walking, is_possessed, belief) -> dynamic sprite

DynamicSprite make_player_sprite() {
  return DynamicSprite([[player_images[0]], [player_images[1]], [player_images[2]], [player_images[3]], [player_images[2]], [player_images[1]]],
                         Location(1, 2), t_anchor: Location(0, -0.5), t_framerate: 8);
}

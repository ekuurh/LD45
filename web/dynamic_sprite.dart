import 'dart:html';
import 'package:tuple/tuple.dart';

import 'resources/resources.dart';
import 'utils.dart';

enum PlayerOutline {
  POSSESSED,
  TARGETED,
  CLEAN
}

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

DynamicSprite get_person_sprite(bool is_walking, bool is_possessed, bool is_targeted, num belief) {
  if(is_possessed) {
    return person_sprites[Tuple3<bool, PlayerOutline, num>(is_walking, PlayerOutline.POSSESSED, belief)];
  }
  if(is_targeted) {
    return person_sprites[Tuple3<bool, PlayerOutline, num>(
        is_walking, PlayerOutline.TARGETED, belief)];
  }
  return person_sprites[Tuple3<bool, PlayerOutline, num>(is_walking, PlayerOutline.CLEAN, belief)];
}

void make_person_sprites() {
  String idle_possession_filepath = 'resources/images/possess_idle.png';
  String step1_possession_filepath = 'resources/images/possess_step1.png';
  String step2_possession_filepath = 'resources/images/possess_step2.png';

  String idle_targeting_filepath = 'resources/images/select_idle.png';
  String step1_targeting_filepath = 'resources/images/select_step1.png';
  String step2_targeting_filepath = 'resources/images/select_step2.png';

  person_sprites = {};
  talking_person_sprites = {};

  for (var amount_possessed = -2; amount_possessed <= 2; amount_possessed++) {
    String filename_suffix;
    if(amount_possessed == -2) filename_suffix = "0";
    if(amount_possessed == -1) filename_suffix = "20";
    if(amount_possessed == 0) filename_suffix = "40";
    if(amount_possessed == 1) filename_suffix = "80";
    if(amount_possessed == 2) filename_suffix = "100";

    String path = 'resources/images/idle_' + filename_suffix + '.png';
    ImageElement idle_sprite = ImageElement(src: path);
    person_sprites[Tuple3<bool, PlayerOutline, num>(false, PlayerOutline.CLEAN, amount_possessed)] = DynamicSprite([[idle_sprite]], Location(1, 1));
    person_sprites[Tuple3<bool, PlayerOutline, num>(false, PlayerOutline.POSSESSED, amount_possessed)] = DynamicSprite([[idle_sprite, ImageElement(src: idle_possession_filepath)]], Location(1, 1));
    person_sprites[Tuple3<bool, PlayerOutline, num>(false, PlayerOutline.TARGETED, amount_possessed)] = DynamicSprite([[idle_sprite, ImageElement(src: idle_targeting_filepath)]], Location(1, 1));

    String path1 = 'resources/images/step1_' + filename_suffix + '.png';
    ImageElement step1_sprite = ImageElement(src: path1);
    String path2 = 'resources/images/step2_' + filename_suffix + '.png';
    ImageElement step2_sprite = ImageElement(src: path2);
    person_sprites[Tuple3<bool, PlayerOutline, num>(true, PlayerOutline.CLEAN, amount_possessed)] = DynamicSprite([[step1_sprite], [step2_sprite]], Location(1, 1));
    person_sprites[Tuple3<bool, PlayerOutline, num>(true, PlayerOutline.POSSESSED, amount_possessed)] = DynamicSprite(
        [[step1_sprite, ImageElement(src: step1_possession_filepath)], [step2_sprite, ImageElement(src: step2_possession_filepath)]], Location(1, 1));
    person_sprites[Tuple3<bool, PlayerOutline, num>(true, PlayerOutline.POSSESSED, amount_possessed)] = DynamicSprite(
        [[step1_sprite, ImageElement(src: step1_targeting_filepath)], [step2_sprite, ImageElement(src: step2_targeting_filepath)]], Location(1, 1));

    talking_person_sprites[Tuple2<bool, num>(true, amount_possessed)] = DynamicSprite([[idle_sprite, talk_left_sprite]], Location(1, 1));
    talking_person_sprites[Tuple2<bool, num>(false, amount_possessed)] = DynamicSprite([[idle_sprite, talk_right_sprite]], Location(1, 1));
  }
}

Map<Tuple3<bool, PlayerOutline, num>, DynamicSprite> person_sprites; // (is_walking, outline, belief) -> dynamic sprite
Map<Tuple2<bool, num>, DynamicSprite> talking_person_sprites; // (is_left, belief) -> dynamic sprite

DynamicSprite make_player_sprite() {
  return DynamicSprite([[player_images[0]], [player_images[1]], [player_images[2]], [player_images[3]], [player_images[2]], [player_images[1]]],
                         Location(1, 2), t_anchor: Location(0, -0.5), t_framerate: 8);
}

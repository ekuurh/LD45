import 'dart:html';
import 'utils.dart';

class DynamicSprite extends Drawable{
  List<ImageElement> frames;
  Location dimensions;
  num framerate;

  num _time_until_swap;
  num _curr_frame;

  DynamicSprite(List<ImageElement> t_frames, Location t_dimensions, {num t_framerate=4}) {
    frames = t_frames;
    dimensions = t_dimensions;
    framerate = t_framerate;
  }

  void draw(CanvasRenderingContext2D ctx, Location loc) {
    ctx.drawImageScaled(frames[_curr_frame], (loc.x - dimensions.x + 1)*TILE_SIZE, (loc.x - dimensions.y + 1)*TILE_SIZE,
        dimensions.x * TILE_SIZE, dimensions.y * TILE_SIZE);
  }

  void update(num dt) {
    _time_until_swap -= dt;
    if(_time_until_swap <= 0.0) {
      _time_until_swap = 1.0/framerate;
      _curr_frame = (_curr_frame + 1) % frames.length;
    }
  }
}

DynamicSprite make_person_sprite(bool is_walking, bool is_possessed, num belief) {
  if((!is_walking) && (!is_possessed)) {
//    return DynamicSprite([])
  }
}
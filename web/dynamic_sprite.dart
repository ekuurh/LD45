import 'dart:html';
import 'utils.dart';

class DynamicSprite : Drawable{
  List<ImageElement> frames;
  num framerate;

  num _last_change_time;
  num _curr_frame;

  DynamicSprite(List<ImageElement> t_frames, {num t_framerate=4}) {
    frames = t_frames;
    framerate = t_framerate;
  }
}

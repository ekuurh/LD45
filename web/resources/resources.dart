import 'dart:html';
import 'package:tuple/tuple.dart';
import '../dynamic_sprite.dart';
import '../person.dart';
import '../persona_sounds.dart';

ImageElement op_screen_image = ImageElement(src: "resources/images/op_screen.jpg");
ImageElement end_screen_image = ImageElement(src: "resources/images/end_screen.jpg");

ImageElement level_lose_screen = ImageElement(src: "resources/images/level_lose_screen.png");
List<ImageElement> level_win_screens = [
  ImageElement(src: "resources/images/level_win_screen_1.jpg"),
  ImageElement(src: "resources/images/level_win_screen_2.jpg"),
  ImageElement(src: "resources/images/level_win_screen_3.jpg"),
  ImageElement(src: "resources/images/level_win_screen_4.jpg"),
  ImageElement(src: "resources/images/level_win_screen_5.jpg"),
  ImageElement(src: "resources/images/level_win_screen_6.jpg"),
  ImageElement(src: "resources/images/level_win_screen_7.jpg")];

ImageElement light_road_tile_image = ImageElement(src: 'resources/images/road_tile_large_light.bmp');
ImageElement light_ground_tile_image = ImageElement(src: 'resources/images/ground_tile_large_light.jpg');
ImageElement dark_road_tile_image = ImageElement(src: 'resources/images/road_tile_large_dark.jpg');
ImageElement dark_ground_tile_image = ImageElement(src: 'resources/images/ground_tile_large_dark.bmp');

ImageElement person_image = ImageElement(src: "resources/images/sprite_test.png");

ImageElement house_large_image = ImageElement(src: 'resources/images/house_large.png');
ImageElement tree1_large_image = ImageElement(src: 'resources/images/tree1_large.png');
ImageElement bush_large_image = ImageElement(src: 'resources/images/bush_large.png');
ImageElement bush_small_image = ImageElement(src: 'resources/images/bush_small.png');

ImageElement tree2_large_image = ImageElement(src: 'resources/images/tree2_large.png');
ImageElement tree2_large_right_image = ImageElement(src: 'resources/images/tree2_large_right.png');
ImageElement tree2_large_left_image = ImageElement(src: 'resources/images/tree2_large_left.png');

List<ImageElement> player_images = [
  ImageElement(src: 'resources/images/player_1.png'),
  ImageElement(src: 'resources/images/player_2.png'),
  ImageElement(src: 'resources/images/player_3.png'),
  ImageElement(src: 'resources/images/player_4.png')
];

ImageElement talk_left_sprite = ImageElement(src: 'resources/images/talk_left.png');
ImageElement talk_right_sprite = ImageElement(src: 'resources/images/talk_right.png');

ImageElement intro_image = ImageElement(src: 'resources/images/intro.png');
ImageElement instruction_image = ImageElement(src: 'resources/images/instructions.png');

ImageElement orb_image = ImageElement(src: 'resources/images/pos_spot.png');

List<PersonaSounds> all_persona_sounds;
List<ImageElement> all_manabars;

void make_all_persona_sounds() {
  all_persona_sounds = [];
  List<String> curr = [];
  for(num ind = 0; ind <= 9; ind++) {
    curr.add('resources/audio/convo Convo_1' + ind.toString() + '.wav');
  }
  all_persona_sounds.add(PersonaSounds(curr));
  curr = [];
  for(num ind = 0; ind <= 9; ind++) {
    curr.add('resources/audio/convo Convo_2' + ind.toString() + '.wav');
  }
  all_persona_sounds.add(PersonaSounds(curr));
  curr = [];
  for(num ind = 0; ind <= 6; ind++) {
    curr.add('resources/audio/convo Convo_3' + ind.toString() + '.wav');
  }
  all_persona_sounds.add(PersonaSounds(curr));
}

void make_all_manabars() {
  all_manabars = [];
  for(num ind = 0; ind <= 10; ind++) {
    all_manabars.add(ImageElement(src: 'resources/images/mana_bar_' + (ind*10).toString() + '.png'));
  }
}
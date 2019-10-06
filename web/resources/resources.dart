import 'dart:html';
import 'package:tuple/tuple.dart';
import '../dynamic_sprite.dart';

ImageElement op_screen_image = ImageElement(src: "resources/images/op_screen.jpg");
ImageElement end_screen_image = ImageElement(src: "resources/images/end_screen.jpg");

ImageElement level_win_screen = ImageElement(src: "resources/images/level_win_screen.png");
ImageElement level_lose_screen = ImageElement(src: "resources/images/level_lose_screen.png");

ImageElement ground_tile_image = ImageElement(src: 'resources/images/ground_tile_large.bmp');
ImageElement road_tile_image = ImageElement(src: 'resources/images/road_tile_large.bmp');

ImageElement person_image = ImageElement(src: "resources/images/sprite_test.png");

ImageElement house_large_image = ImageElement(src: 'resources/images/house_large.png');
ImageElement tree1_large_image = ImageElement(src: 'resources/images/tree1_large.png');
ImageElement tree2_large_image = ImageElement(src: 'resources/images/tree2_large.png');
ImageElement bush_large_image = ImageElement(src: 'resources/images/bush_large.png');
ImageElement bush2_image = ImageElement(src: 'resources/images/bush2.bmp');

List<ImageElement> player_images = [
  ImageElement(src: 'resources/images/player_1.png'),
  ImageElement(src: 'resources/images/player_2.png'),
  ImageElement(src: 'resources/images/player_3.png'),
  ImageElement(src: 'resources/images/player_4.png')
];
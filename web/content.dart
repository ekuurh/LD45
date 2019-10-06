import 'package:tuple/tuple.dart';

import 'level.dart';
import 'obstacle.dart';
import 'resources/resources.dart';
import 'worldmap.dart';
import 'utils.dart';
import 'person.dart';
import 'audio.dart';


Level levelIntro = Level(WorldMap.fromString("""
GGGggGGGGggGGGG
RRgRRgRRgRRgGGg
GRRRRRrrrrrrrrg
GRgGRRRRGggRrrg
GRRRRrRRrrrRRRG
GRGRRrrrrRRRRRG
gRGRRrrrrRRRRRG
ggGgGGgGrGgGggG
gggggGGgRRGgggG
GGGGGgGgRRGGGgg


"""),
    pesrons_from_string("""

1,6;4|3,6;2|0
10,6;1|3,6;10|0
2,4;1|6,2;1|0
13,2;5|6,2;2|0
5,2;3|10,2;3|0


      """),
    obstacles_from_string("""
--t--t--t--tT-t
-H--H--H--H-t-t
--------------T
T--b-----------
-------H-------
T------------H-
T--------------
-t-tT-------t-t
TT-t-t-b--t-T-t
T-tT-t-t-H-t-tT

      """),
    30, level_win_screens[2],
      t_music: get_village_music1()
);


Level level11 = Level(WorldMap.fromString("""
ggggggggggg
grrrgrrrrrg
grgrgrrggrg
grgrrrgrrrg
grgrrrrrrrg
grgrrrrrrrg
grgrrrrrrrg
grgrrrrrgrg
grrrrrrrrrg
ggggggggggg

"""),
    pesrons_from_string("""
1,1;6|9,2;1|-1
3,6;2|1,8;2|-1
5,2;2|5,4;2|0

      """),
    obstacles_from_string("""
-H-H-H-H-H-
-----------
-----------
----T-T----
-----------
-----------
-----------
--------H--
-----t-----
-----------

      """),
    60, level_win_screens[1],
      t_music: get_village_alt_music()
);

Level level2 = Level(WorldMap.fromString("""
gggggggggggg
grrrgrgggggg
grrrrrrrrrgg
grgggrrrrggg
grgggrrGrggg
grrrggggrrgg
grrrrrrggrrg
grrrggrggrrg
grrrggrrrrrg
gggggggggggg

"""),
    pesrons_from_string("""

3,1;2|9,2;2|1
10,6;1|7,3;0|-1
1,7;1|10,7;1|-1

      """),
    obstacles_from_string("""
-H-H-H-H-H-H
----T-------
------------
-----------H
----H-HT----
-----t-t---H
------------
-------T----
-----H------
------------

      """),
    30, level_win_screens[2],
      t_music: get_village_music1()
);



List<Level> all_levels = [levelIntro, level2];


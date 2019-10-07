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

1,6;2|3,6;2|0
10,6;1|3,6;10|0
2,4;4|6,2;1|0
13,2;5|1,2;2|0
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
      t_music: get_village_music1()
);

Level level12 = Level(WorldMap.fromString("""
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
      t_music: get_village_music2()
);

Level level13 = Level(WorldMap.fromString("""
GggGGGgGGgggGG
GrrRRRRRRRRrrg
GrRRggRRggRRrg
gRRRggRRGgRRRG
gRRRGgrrGgRRRG
GRRRGgrrGgRRRG
gRRRGGRRgGRRRG
grRRgGRRggRRrg
GrrRRRRRRRRrrg
GGgggGGGgGGGgg

"""),
    pesrons_from_string("""

11,1;2|1,8;2|0
12,2;3|12,8;3|-2
7,3;4|12,8;2|-1
6,3;4|6,6;4|-2
4,8;6|1,8;6|-1


      """),
    obstacles_from_string("""

--H--H---H--H-
--------------
-----T--T-----
---H-------H--
T----b-------T
T--H-----b-H-T
--------------
---H-T--T--H--
--------------
--------------

      """),
    100, level_win_screens[2],
      t_music: get_village_music2()
);


Level level14 = Level(WorldMap.fromString("""
gggggggggggggggg
ggggggggggggggRg
gRRRRRRGGGGgggRg
GRRRRRRRRGGGGGRG
GRRRRRRRRRRRRRRG
GRRRRRRgGRggGGGG
GRRRRRRgGRGggGGG
gRRRRRRggRGGGGGG
gRGGgggggggggGGG
gRRRRRRRRRRRRGGG
gRGGGgggggggRggG
GRRRRRRRRRRRRggg
GGggggGGGgggGGGg

"""),
    pesrons_from_string("""

1,7;6|5,2;2|0
12,9;2|11,1;2|-1
9,6;2|9,4;2|-2
14,4;2|14,2;2|2
9,4;3|14,4;3|0



      """),
    obstacles_from_string("""

------t-t-t----
-t-t-t-t-t-t-H--
-------TT-------
-------------T--
---H-H--H-------
-------BT-------
-------BB-------
-------BB------H
--T-------------
----------------
--BBBBBBBBBB----
B------------T--
-----B-b--------

      """),
    100, level_win_screens[2],
      t_music: get_village_music2()
);

List<Level> all_levels = [levelIntro, level11, level12, level13];


import 'package:tuple/tuple.dart';

import 'level.dart';
import 'obstacle.dart';
import 'resources/resources.dart';
import 'worldmap.dart';
import 'utils.dart';
import 'person.dart';
import 'audio.dart';

Level test_level = Level(WorldMap.fromString("""
rrr
ggr
rrr
"""),
    pesrons_from_string("""
0,0;1|2,2;0|-2
2,2;1|1,2;0|2
      """),
    obstacles_from_string("""
---
---
---
      """),
    30, level_win_screens[6],
      t_music: get_village_music1()
);

Level level0 = Level(WorldMap.fromString("""
RRRRRRRR
rrrGrGGr
rGGGrGrr
rrrrrrrg
rggrggrg
rrrrggrr
rggrggrr
rrrrrrrg
"""),
      pesrons_from_string("""
0,0;1|2,1;1|5,3;1|0
      """),
      obstacles_from_string("""
--------
--------
--H-----
---tT---
----b---
--------
--------
--------
      """), 70, level_win_screens[0],
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
1,1;1|9,2;6|-1
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
grgggrrrrrrg
grrrggggrrrg
grrrrrrggrrg
grrrggrggrrg
grrrggrrrrrg
gggggggggggg

"""),
    pesrons_from_string("""

3,1;2|9,2;2|1
10,6;0|7,3;1|-1
1,7;1|10,7;1|-1

      """),
    obstacles_from_string("""
-H-H-H-H-H-H
----T-------
------------
-----------H
----H-H-----
-----t-t---H
------------
-------T----
-----H------
------------

      """),
    30,
      t_music: get_village_music1()
);

List<Level> all_levels = [level2];


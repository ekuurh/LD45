import 'package:tuple/tuple.dart';

import 'level.dart';
import 'obstacle.dart';
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
    30,
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
      """), 70,
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
1,1;2|9,2;2|-2
3,6;2|1,8;2|-2
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
    60,
      t_music: get_village_alt_music()
);

List<Level> all_levels = [level0, level11];


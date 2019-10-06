import 'package:tuple/tuple.dart';

import 'level.dart';
import 'obstacle.dart';
import 'worldmap.dart';
import 'utils.dart';
import 'person.dart';
import 'audio.dart';

Level test_level = Level(WorldMap.fromString("""
rrrg
rgrr
rrgr
rrrr
grrg
"""),
    pesrons_from_string("""
1,0;0|1,2;1|-2
2,1;0|0,2;1|0
1,4;0|0,0;1|3,1;1|-1
0,0;0|2,4;0|3,2;1|-1
      """),
    obstacles_from_string("""
----
----
----
----
----
      """),
    30,
      t_music: get_village_music1()
);

Level level0 = Level(WorldMap.fromString("""
rrrrrrrr
rrrgrggr
rgggrgrr
rrrrrrrg
rggrggrg
rrrrggrr
rggrggrr
rrrrrrrg
"""),
      pesrons_from_string("""
0,0;1|2,1;1|5,3;1|-1
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
    t_music: get_village_alt_music()
);

List<Level> all_levels = [test_level, level0];

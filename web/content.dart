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
    [Person([Tuple2<Location, num>(Location(1, 0), 1), Tuple2<Location, num>(Location(1, 2), 1)], belief: -2),
      Person([Tuple2<Location, num>(Location(2, 1), 1), Tuple2<Location, num>(Location(0, 2), 1)], belief: 0),
      Person([Tuple2<Location, num>(Location(1, 4), 1), Tuple2<Location, num>(Location(0, 0), 1), Tuple2<Location, num>(Location(3, 1), 1)], belief: -1),
      Person([Tuple2<Location, num>(Location(0, 0), 1), Tuple2<Location, num>(Location(2, 4), 1), Tuple2<Location, num>(Location(3, 2), 1)], belief: -1)],
      [], 30,
      t_music: village_music1
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
      [Person([Tuple2<Location, num>(Location(0, 0), 1), Tuple2<Location, num>(Location(2, 1), 1), Tuple2<Location, num>(Location(5, 3), 1)])],
      obstacles_from_string("""
--------
--------
--H-----
---tT---
----b---
--------
--------
--------
      """)
/*      [Tuple2(make_house(), Location(2, 2)),
      Tuple2(make_tree1(), Location(3, 3)),
      Tuple2(make_tree2(), Location(4, 3)),
      Tuple2(make_bush1(), Location(3, 4)),
      Tuple2(make_bush2(), Location(4, 4))]*/, 70,
    t_music: village_alt_music
);

List<Level> all_levels = [/*test_level, */level0];

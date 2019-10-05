import 'package:tuple/tuple.dart';

import 'level.dart';
import 'obstacle.dart';
import 'worldmap.dart';
import 'utils.dart';
import 'person.dart';

Level test_level = Level(WorldMap.fromString("""
rrrg
rgrr
rrgr
rrrr
grrg
"""),
    [Person([Location(1, 0), Location(1, 2)]),
      Person([Location(2, 1), Location(0, 2)]),
      Person([Location(1, 4), Location(0, 0), Location(3, 1)]),
      Person([Location(0, 0), Location(2, 4), Location(3, 2)])],
      []
);

Level level0 = Level(WorldMap.fromString("""
rrrrrrrr
rgggrggr
rgggrgrr
rrrrrrrg
rggrggrg
rrrrggrr
rggrggrr
rrrrrrrg
"""),
     [Person([Location(1, 0), Location(7, 2), Location(0, 3)]),
      Person([Location(3, 0), Location(4, 7)]),
      Person([Location(6, 3), Location(2, 7), Location(0, 3)]),
      Person([Location(7, 0), Location(6, 7), Location(0, 5)])],
      [Tuple2(make_house(), Location(2, 2))]
);

List<Level> all_levels = [test_level, level0];

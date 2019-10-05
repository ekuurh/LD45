import 'level.dart';
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
      Person([Location(0, 0), Location(2, 4), Location(3, 2)])]
);

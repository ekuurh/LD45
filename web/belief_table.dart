import 'package:tuple/tuple.dart';

Map<Tuple2<num, num>, Tuple2<num, num>> belief_table = {
  Tuple2<num, num>(2, 2): Tuple2<num, num>(2, 2),
  Tuple2<num, num>(2, 1): Tuple2<num, num>(2, 2),
  Tuple2<num, num>(2, 0): Tuple2<num, num>(2, 1),
  Tuple2<num, num>(2, -1): Tuple2<num, num>(1, 0),
  Tuple2<num, num>(2, -2): Tuple2<num, num>(1, -1),
  Tuple2<num, num>(1, 1): Tuple2<num, num>(1, 1),
  Tuple2<num, num>(1, 0): Tuple2<num, num>(1, 1),
  Tuple2<num, num>(1, -1): Tuple2<num, num>(0, 0),
  Tuple2<num, num>(1, -2): Tuple2<num, num>(0, -1),
  Tuple2<num, num>(0, 0): Tuple2<num, num>(0, 0),
  Tuple2<num, num>(0, -1): Tuple2<num, num>(0, -1),
  Tuple2<num, num>(0, -2): Tuple2<num, num>(-1, -2),
  Tuple2<num, num>(-1, -1): Tuple2<num, num>(-1, -1),
  Tuple2<num, num>(-1, -2): Tuple2<num, num>(-1, -2),
  Tuple2<num, num>(-2, -2): Tuple2<num, num>(-2, -2)
};

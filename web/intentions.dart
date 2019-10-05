import 'world.dart';
import 'utils.dart';

void advance_all_persons(World world) {
  var person_to_direction = {};
  var location_to_interested_persons = {};
  for(var person in world.persons) {
    Direction dir = person.get_wanted_direction(world.map);
    person_to_direction[person] = dir;
    location_to_interested_persons[location_add(person.location, dir)] = person;
  }
}

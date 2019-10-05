import 'world.dart';
import 'map.dart';
import 'person.dart';
import 'utils.dart';

void advance_all_persons(World world) {
  var person_to_direction = {};
  var location_to_interested_persons = {};
  for(var person in world.persons) {
    Direction dir = person.get_wanted_direction(world.map);
    person_to_direction[person] = dir;
    var curr_list = location_to_interested_persons[location_add(person.location, dir)];
    if(curr_list == null) {
      curr_list = [];
    }
    curr_list.append(person);
  }

  var empty_locations = [];
  for(num x = 0; x < world.map.width; x++) {
    for(num y = 0; y < world.map.height; y++) {
      if((world.map.tiles[x][y].is_walkable) && (location_to_interested_persons[Location(x, y)] == null)) {
        empty_locations.add(Location(x, y));
      }
    }
  }

  for(var ind = 0; ind < empty_locations.length; ind++) {
    var curr_location = empty_locations[ind];
    if(location_to_interested_persons[curr_location] == null) {
      continue;
    }
    Person picked_person = location_to_interested_persons[curr_location][0];
    for(var person in location_to_interested_persons[curr_location]) {
      if(person_to_direction[person] == Direction.STAY) {
        picked_person = person;
      }
    }
    empty_locations.add(picked_person.location);
    picked_person.walk_in_direction(person_to_direction[picked_person]);
  }
}

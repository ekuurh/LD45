import 'package:howler/howler.dart';
import 'person.dart';
import 'persona_sounds.dart';
import 'utils.dart';

const num MAX_CONVERSATION_VOLUME = 0.3;
//const num MAX_CONVERSATION_DISTANCE = 4;

class ConversationVibe {
  Location location;
  Howl sound;
  num time_left;

  ConversationVibe(this.location, PersonaSounds sounds1, PersonaSounds sounds2) {
    num num_sounds = 10;
    List<String> person1_sounds = generate_random_list_from_pool(sounds1.sound_paths, num_sounds);
    List<String> person2_sounds = generate_random_list_from_pool(sounds2.sound_paths, num_sounds);
    List<String> all_sounds = [];
    for(num ind = 0; ind < num_sounds; ind++) {
      all_sounds.add(person1_sounds[ind]);
      all_sounds.add(person2_sounds[ind]);
    }
    sound = Howl(
        src: all_sounds, // source in MP3 and WAV fallback
        loop: false,
        volume: MAX_CONVERSATION_VOLUME // Play with 60% of original volume.
    ) ;
    sound.play();
    time_left = CONVERSATION_TIME;
  }

  void update(num dt, Location player_location) {
//    num dist = Location.distance(player_location, location);
//    sound.setVolume(Location.distance(player_location, location))
    if(time_left == 0.0) {
      return;
    }
    time_left -= dt / CLOCK_TIME;
    if(time_left <= 0.0) {
      time_left = 0;
      sound.mute(true);
    }
  }
}

import 'package:howler/howler.dart';

Howl get_main_menu_music(){ return new Howl(
    src: ['resources/audio/Main menu.wav'], // source in MP3 and WAV fallback
    loop: true,
    volume: 1.00 // Play with 60% of original volume.
) ; }

Howl get_village_music1(){ return new Howl(
src: ['resources/audio/Village music 1.wav'], // source in MP3 and WAV fallback
loop: true,
volume: 1.00 // Play with 60% of original volume.
) ; }

Howl get_village_music2(){ return new Howl(
src: ['resources/audio/Village music 2.wav'], // source in MP3 and WAV fallback
loop: true,
volume: 1.00 // Play with 60% of original volume.
) ; }

Howl get_another_music(){ return new Howl(
src: ['resources/audio/Another music.wav'], // source in MP3 and WAV fallback
loop: true,
volume: 1.00 // Play with 60% of original volume.
) ; }

Howl get_village_alt_music(){ return new Howl(
src: ['resources/audio/Village alt music.wav'], // source in MP3 and WAV fallback
loop: true,
volume: 1.00 // Play with 60% of original volume.
) ; }

Howl get_tree_fall_sound() { return new Howl(
    src: ['resources/audio/tree_fall.wav'], // source in MP3 and WAV fallback
    loop: false,
    volume: 1.00 // Play with 60% of original volume.
) ; }

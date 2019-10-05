import 'package:howler/howler.dart';

var main_menu_music = new Howl(
    src: ['resources/audio/Main menu.wav'], // source in MP3 and WAV fallback
    loop: true,
    volume: 0.60 // Play with 60% of original volume.
) ;

var village_music1 = new Howl(
    src: ['resources/audio/Village music 1.wav'], // source in MP3 and WAV fallback
    loop: true,
    volume: 0.60 // Play with 60% of original volume.
) ;

var village_music2 = new Howl(
    src: ['resources/audio/Village music 2.wav'], // source in MP3 and WAV fallback
    loop: true,
    volume: 0.60 // Play with 60% of original volume.
) ;
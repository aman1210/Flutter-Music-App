import 'package:flutter/foundation.dart';
import 'package:SoulMusic/providers/songs_provider.dart' show Song;
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';

class NowPlaying extends ChangeNotifier {
  Song _song;
  AudioPlayer audioPlayer;

  AudioCache audioCache;
  Duration duration = Duration();
  Duration position = Duration();
  var isInit = false;

  Song get song {
    return _song;
  }

  Future<void> init() async {
    audioPlayer = AudioPlayer();

    audioCache = AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.onDurationChanged.listen((d) {
      duration = d;
      notifyListeners();
    });

    audioPlayer.onAudioPositionChanged.listen((d) {
      position = d;
      notifyListeners();
    });

    // audioPlayer.onPlayerCompletion.listen((event) {
    //   print(audioPlayer.state);
    // });
  }

  void loadSong() async {
    // await audioPlayer.stop();
    int result = await audioPlayer.play(_song.url);
    if (result == 1) {
      MediaNotification.showNotification(
          author: _song.artist, title: _song.title);
    }
  }

  Future<void> pause() async {
    await audioPlayer.pause();

    MediaNotification.showNotification(
        author: _song.artist, title: _song.title, isPlaying: false);
    // notifyListeners();
  }

  Future<void> resume() async {
    await audioPlayer.resume();

    MediaNotification.showNotification(
        author: _song.artist, title: _song.title, isPlaying: true);
    // notifyListeners();
  }

  void next() {}

  void seekToChange(int seconds) {
    Duration newDuration = Duration(seconds: seconds);
    audioPlayer.seek(newDuration);
    notifyListeners();
  }

  void setSong(Song song) async {
    // print(song.title);
    // print(audioPlayer.state == AudioPlayerState.PLAYING);
    _song = song;

    loadSong();
    notifyListeners();
  }
}

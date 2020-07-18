import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/songs_provider.dart';
import '../providers/now_playing_provider.dart';
import '../screens/now_playing_screen.dart';

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with SingleTickerProviderStateMixin {
  Duration _duration = Duration();
  Duration _position = Duration();
  AnimationController animationController;
  var songFetched = false;
  var isPlaying = true;
  var nextSong;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    init();
  }

  void init() {
    var provider = Provider.of<NowPlaying>(context, listen: false);
    provider.init();
    provider.audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    provider.audioPlayer.onAudioPositionChanged.listen((p) {
      // print(p);
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var nowPlaying = Provider.of<NowPlaying>(context);
    Song song = nowPlaying.song;
    if (song != null && songFetched == false) {
      nowPlaying.loadSong();
      songFetched = true;
    }
    nowPlaying.audioPlayer.onPlayerCompletion.listen((event) {
      nextSong =
          Provider.of<Songs>(context, listen: false).findNextSong(song.id);
      if (nextSong != null) {
        song = nextSong;
        nowPlaying.setSong(nextSong);
      }
    });

    // print(nowPlaying.audioPlayer.state);
    return nowPlaying.audioPlayer == null
        ? Text('Loading...')
        : Stack(
            overflow: Overflow.visible,
            children: [
              DefaultTabController(
                length: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 1),
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      song == null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.library_music,
                                size: 45,
                              ),
                            )
                          : Hero(
                              tag: song.albumArt,
                              child: Image.network(
                                song.albumArt,
                                height: 70,
                                width: 70,
                              ),
                            ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onVerticalDragStart: (details) {
                                if (song == null) {
                                } else {
                                  Navigator.of(context).pushNamed(
                                    NowPlayingScreen.routeName,
                                    arguments: song.id,
                                  );
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    song == null ? 'Select Song' : song.title,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    song == null
                                        ? ''
                                        : '${song.artist} - ${song.album}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey
                                            : Colors.grey[700]),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: IconButton(
                          splashColor: Colors.transparent,
                          icon: AnimatedIcon(
                            icon: AnimatedIcons.pause_play,
                            progress: animationController,
                            // size: 40,
                          ),
                          onPressed: song == null
                              ? null
                              : () async {
                                  if (!isPlaying) {
                                    await nowPlaying.pause();
                                  } else {
                                    await nowPlaying.resume();
                                  }
                                  setState(() {
                                    print(isPlaying);
                                    isPlaying = !isPlaying;
                                    isPlaying
                                        ? animationController.forward()
                                        : animationController.reverse();
                                  });
                                },
                        ),
                      ),

                      // SizedBox(
                      //   width: 10,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}

import 'package:SoulMusic/providers/auth_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../providers/songs_provider.dart';
import '../providers/now_playing_provider.dart';

class NowPlayingController extends StatefulWidget {
  final Song song;
  final Function changeSong;
  final bool isLiked;
  NowPlayingController(this.song, this.changeSong, this.isLiked);
  @override
  _NowPlayingControllerState createState() => _NowPlayingControllerState();
}

class _NowPlayingControllerState extends State<NowPlayingController>
    with SingleTickerProviderStateMixin {
  Duration _duration = Duration();
  Duration _position = Duration();
  AnimationController animationController;
  var nextSong;
  var songFetched = false;
  var isPlaying = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    init();
  }

  void init() {
    var provider = Provider.of<NowPlaying>(context, listen: false);
    // provider.init();
    isPlaying = provider.audioPlayer.state == AudioPlayerState.PLAYING;
    provider.audioPlayer.onDurationChanged.listen((d) {
      if (mounted) {
        setState(() {
          _duration = d;
        });
      }
    });
    provider.audioPlayer.onAudioPositionChanged.listen((p) {
      // print(p);
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });
  }

  Song onForward(String id) {
    return Provider.of<Songs>(context, listen: false).findNextSong(id);
  }

  Song onPrevious(String id) {
    return Provider.of<Songs>(context, listen: false).findPreviousSong(id);
  }

  @override
  Widget build(BuildContext context) {
    var nowPlaying = Provider.of<NowPlaying>(context);
    nowPlaying.audioPlayer.onPlayerCompletion.listen((event) {
      nextSong = Provider.of<Songs>(context, listen: false)
          .findNextSong(widget.song.id);
      if (nextSong != null) {
        nowPlaying.setSong(nextSong);
        widget.changeSong(nextSong.id);
      }
    });
    return Column(
      children: <Widget>[
        Container(
          child: Slider(
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).primaryColor,
            value: _position.inSeconds.toDouble(),
            min: 0.0,
            max: _duration.inSeconds.toDouble(),
            onChanged: (double value) {
              if (mounted) {
                setState(() {
                  nowPlaying.seekToChange(value.toInt());
                  value = value;
                });
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: IconButton(
                      icon: Icon(
                        Icons.playlist_add,
                        size: 30,
                      ),
                      onPressed: () {
                        bool result = Provider.of<Auth>(context, listen: false)
                            .addToPlaylist(widget.song.id);
                        if (result == false) {
                          Toast.show('Already in your playlist', context,
                              duration: 1, backgroundColor: Colors.black);
                        } else {
                          Toast.show('Added to your playlist', context,
                              duration: 1, backgroundColor: Colors.black);
                        }
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.fast_rewind,
                      size: 30,
                    ),
                    onPressed: () {
                      var song = onPrevious(widget.song.id);
                      if (song != null) {
                        nowPlaying.setSong(song);
                        widget.changeSong(song.id);
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).accentColor),
                  child: IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: animationController,
                    ),
                    onPressed: () async {
                      if (isPlaying) {
                        await nowPlaying.pause();
                      } else {
                        await nowPlaying.resume();
                      }
                      setState(() {
                        isPlaying = !isPlaying;
                        isPlaying
                            ? animationController.forward()
                            : animationController.reverse();
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.fast_forward,
                      size: 30,
                    ),
                    onPressed: () {
                      var song = onForward(widget.song.id);
                      if (song != null) {
                        nowPlaying.setSong(song);
                        widget.changeSong(song.id);
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: IconButton(
                    icon: Icon(
                      widget.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: widget.isLiked ? Colors.red : Colors.grey,
                    ),
                    splashColor: Colors.red,
                    onPressed: () {
                      Provider.of<Auth>(context, listen: false)
                          .toggleLiked(widget.song.id);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

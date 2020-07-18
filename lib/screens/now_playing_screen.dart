import 'package:SoulMusic/providers/auth_provider.dart';
import 'package:SoulMusic/providers/now_playing_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/songs_provider.dart';
import '../widgets/now_playing_controller.dart';

class NowPlayingScreen extends StatefulWidget {
  static const routeName = '/now-playing-screen';
  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  var songId;
  void songChange(String id) {
    setState(() {
      songId = id;
      print('changing Song');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (songId == null)
      songId = ModalRoute.of(context).settings.arguments as String;
    var song = Provider.of<Songs>(context, listen: false).findById(songId);
    var isLiked = Provider.of<Auth>(context).isLiked(song.id);
    print(isLiked);
    final List<Song> songs = Provider.of<Songs>(context, listen: false).songs;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                song.title,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      backgroundColor: Colors.black87,
                      color: Colors.white,
                    ),
              ),
              background: Hero(
                tag: song.albumArt,
                child: Image.network(
                  song.albumArt,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                NowPlayingController(song, songChange, isLiked),
                Container(
                  child: Column(
                    children: songs.map((s) {
                      if (s.id == songId) {
                        return Card(
                          elevation: 10,
                          child: ListTile(
                            title: Text(
                              s.title,
                              style: TextStyle(color: Colors.blue),
                            ),
                            trailing: Icon(
                              Icons.music_note,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      } else {
                        return ListTile(
                          onTap: () {
                            Provider.of<NowPlaying>(context, listen: false)
                                .setSong(s);
                            setState(() {
                              songId = s.id;
                            });
                          },
                          title: Text(s.title),
                        );
                      }
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

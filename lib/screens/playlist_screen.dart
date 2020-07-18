import 'package:SoulMusic/providers/auth_provider.dart';
import 'package:SoulMusic/providers/songs_provider.dart';
import 'package:SoulMusic/widgets/playlist_liked_song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatelessWidget {
  static const routeName = '/playlist';

  @override
  Widget build(BuildContext context) {
    var playlist = Provider.of<Auth>(context, listen: false).playlist;
    Provider.of<Songs>(context, listen: false).setPlaylist(playlist);
    var songs = Provider.of<Songs>(context).playlist;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your playlist!'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return PlaylistLikedSong(
            song: songs[index],
          );
        },
        itemCount: songs.length,
      ),
    );
  }
}

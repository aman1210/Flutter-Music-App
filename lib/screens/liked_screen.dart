import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/songs_provider.dart';
import '../widgets/liked_song.dart';

class LikedScreen extends StatelessWidget {
  static const routeName = '/liked';
  @override
  Widget build(BuildContext context) {
    var liked = Provider.of<Auth>(context, listen: false).liked;
    Provider.of<Songs>(context, listen: false).setliked(liked);
    var songs = Provider.of<Songs>(context).liked;
    return Scaffold(
      appBar: AppBar(
        title: Text('Yours favorite'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return LikedSong(
            song: songs[index],
          );
        },
        itemCount: songs.length,
      ),
    );
  }
}

import 'package:SoulMusic/providers/auth_provider.dart';
import 'package:SoulMusic/providers/now_playing_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/songs_provider.dart';

class SearchSong extends StatelessWidget {
  final Song song;
  SearchSong({
    this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: FadeInImage(
          placeholder: AssetImage('assests/images/placeholder.png'),
          image: NetworkImage(song.albumArt),
          fit: BoxFit.cover,
        ),
        title: Text(song.title),
        trailing: IconButton(
            icon: Icon(
              Icons.play_circle_filled,
              color: Colors.green,
              size: 30,
            ),
            onPressed: () {
              Scaffold.of(context).removeCurrentSnackBar();
              Provider.of<NowPlaying>(context, listen: false).setSong(song);
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Playing "${song.title}"',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

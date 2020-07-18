import 'package:SoulMusic/providers/auth_provider.dart';
import 'package:SoulMusic/providers/now_playing_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/songs_provider.dart';

class PlaylistLikedSong extends StatelessWidget {
  final Song song;
  PlaylistLikedSong({
    this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Dismissible(
        key: Key(song.id),
        background: Container(
          color: Colors.red,
          child: Icon(Icons.delete_forever),
        ),
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Are You Sure?'),
                content: Text('Do you want to delete item from the playlist?'),
                elevation: 20,
                actions: <Widget>[
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    icon: Icon(Icons.clear),
                    label: Text('No'),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    icon: Icon(Icons.check),
                    label: Text('Yes'),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          Provider.of<Auth>(context, listen: false).deleteFromPlaylist(song.id);
        },
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
      ),
    );
  }
}

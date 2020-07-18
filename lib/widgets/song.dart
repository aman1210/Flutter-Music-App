import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../providers/songs_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/now_playing_provider.dart';

class SongShow extends StatelessWidget {
  final Song song;
  SongShow(this.song);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    return Padding(
      padding: EdgeInsets.only(top: height / 2 - 320),
      child: GestureDetector(
        onTap: () {
          Provider.of<NowPlaying>(context, listen: false).setSong(song);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
                  if (Theme.of(context).brightness == Brightness.light)
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      offset: Offset(5, 5),
                    )
                ],
              ),
              child: FadeInImage(
                placeholder: AssetImage('assests/images/placeholder.png'),
                image: NetworkImage(song.albumArt),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 302,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                boxShadow: [
                  if (Theme.of(context).brightness == Brightness.light)
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      offset: Offset(5, 5),
                    )
                ],
              ),
              child: ListTile(
                leading: Icon(
                  Icons.music_note,
                  size: 35,
                ),
                title: Text(song.title),
                subtitle: Text(
                  song.artist,
                ),
                trailing: Tooltip(
                  message: 'Add to playlist',
                  child: IconButton(
                    icon: Icon(Icons.playlist_add),
                    onPressed: () {
                      bool result = Provider.of<Auth>(context, listen: false)
                          .addToPlaylist(song.id);
                      if (result == false) {
                        Toast.show('Already in your playlist', context,
                            duration: 1, backgroundColor: Colors.black);
                      } else {
                        Toast.show('Added to your playlist', context,
                            duration: 1, backgroundColor: Colors.black);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

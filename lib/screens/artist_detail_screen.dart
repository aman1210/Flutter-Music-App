import 'package:SoulMusic/widgets/song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/artist_provider.dart';
import '../providers/songs_provider.dart';
import '../providers/now_playing_provider.dart';

class ArtistDetailScreen extends StatelessWidget {
  static const routeName = '/auth-detail-screen';
  @override
  Widget build(BuildContext context) {
    final artistId = ModalRoute.of(context).settings.arguments as String;
    final artist =
        Provider.of<Artists>(context, listen: false).findById(artistId);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.network(
                artist.artistImage,
                fit: BoxFit.cover,
              ),
              title: Text(
                artist.artist,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(backgroundColor: Colors.black87),
                textAlign: TextAlign.center,
              ),
              titlePadding: EdgeInsets.only(bottom: 20),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
            [
              SizedBox(
                height: 10,
              ),
              Container(
                // height: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: artist.songs.map(
                    (sId) {
                      var song = Provider.of<Songs>(context, listen: false)
                          .findById(sId);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: ListTile(
                          leading: FadeInImage(
                            placeholder:
                                AssetImage('assests/images/placeholder.png'),
                            image: NetworkImage(song.albumArt),
                            fit: BoxFit.cover,
                          ),
                          title: Text(song.title),
                          subtitle: Text(song.album),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.play_arrow,
                                color: Colors.green[400],
                              ),
                              onPressed: () {
                                Provider.of<NowPlaying>(context, listen: false)
                                    .setSong(song);
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
                    },
                  ).toList(),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/artist_provider.dart';
import '../screens/artist_detail_screen.dart';

class ArtistScreen extends StatefulWidget {
  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  List<Artist> artists = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Artists>(context, listen: false).fetchAndSetArtists();
  }

  @override
  Widget build(BuildContext context) {
    artists = Provider.of<Artists>(context).artist;
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            child: GridTile(
              child: InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                      ArtistDetailScreen.routeName,
                      arguments: artists[index].id),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      placeholder: AssetImage('assests/images/logoHead.png'),
                      image: NetworkImage(artists[index].artistImage),
                      fit: BoxFit.cover,
                    ),
                  )),
              footer: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black87,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  artists[index].artist,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic),
                ),
              ),
            ),
          );
        },
        itemCount: artists.length,
      ),
    );
  }
}

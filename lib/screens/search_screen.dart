import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/artist_provider.dart';
import '../providers/songs_provider.dart';
import './artist_detail_screen.dart';
import '../widgets/search_song.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  final textFocus = FocusNode();
  String currentItem = 'Songs';
  List<Song> songs = [];
  List<Artist> artists = [];
  void search() {
    if (currentItem == 'Songs' && searchController.text.length > 0) {
      setState(() {
        songs = Provider.of<Songs>(context, listen: false)
            .search(searchController.text);
      });
    }
    if (currentItem == 'Artist' && searchController.text.length > 0) {
      setState(() {
        artists = Provider.of<Artists>(context, listen: false)
            .search(searchController.text);
      });
    }
  }

  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    search();
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            textDirection: TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Container(
                width: mediaQuery.size.width * 0.70,
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Search'),
                  controller: searchController,
                  focusNode: textFocus,
                  onChanged: (value) {
                    if (searchController.text.trim().length == 0) {
                      setState(() {
                        songs = [];
                        artists = [];
                      });
                    }
                    search();
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              DropdownButton(
                items: [
                  DropdownMenuItem(
                    child: Text('Songs'),
                    value: 'Songs',
                  ),
                  DropdownMenuItem(
                    child: Text('Artist'),
                    value: 'Artist',
                  ),
                ],
                onChanged: (value) {
                  print(value);
                  setState(() {
                    currentItem = value;
                  });
                },
                value: currentItem,
                itemHeight: 67,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (searchController.text.length == 0)
            Expanded(
              child: Center(
                child: Icon(
                  Icons.search,
                  size: 70,
                  color: Colors.grey,
                ),
              ),
            ),
          if (searchController.text.length != 0 &&
              (songs.length == 0 && artists.length == 0))
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    size: 70,
                    color: Colors.grey,
                  ),
                  Text(
                    'Not Found',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          if (currentItem == 'Songs' && songs.length > 0)
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemBuilder: (context, index) => SearchSong(
                    song: songs[index],
                  ),
                  itemCount: songs.length,
                ),
              ),
            ),
          if (currentItem == 'Artist')
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: FadeInImage(
                        placeholder: AssetImage('assests/images/logoHead.png'),
                        image: NetworkImage(artists[index].artistImage),
                        fit: BoxFit.cover,
                      ),
                      title: Text(artists[index].artist),
                      onTap: () => Navigator.of(context).pushNamed(
                        ArtistDetailScreen.routeName,
                        arguments: artists[index].id,
                      ),
                    ),
                  ),
                  itemCount: artists.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

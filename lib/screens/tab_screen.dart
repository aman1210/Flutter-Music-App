import 'package:SoulMusic/providers/auth_provider.dart';
import 'package:SoulMusic/screens/artist_screen.dart';
import 'package:SoulMusic/screens/audio_player.dart';
import 'package:SoulMusic/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';

import './home_screen.dart';
import './search_screen.dart';
import '../providers/songs_provider.dart';
import '../providers/now_playing_provider.dart';

class TabScreen extends StatefulWidget {
  static final int selectedPos = 1;

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int currentPage = 0;
  List<Widget> screens = [
    HomeScreen(),
    ArtistScreen(),
    SearchScreen(),
  ];
  @override
  void initState() {
    super.initState();
    MediaNotification.setListener('play', () async {
      setState(() {
        print('playing');
        Provider.of<NowPlaying>(context, listen: false).resume();
      });
    });
    MediaNotification.setListener('pause', () {
      setState(() {
        print('paused');
        Provider.of<NowPlaying>(context, listen: false).pause();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              'assests/images/logoHead.png',
              height: 40,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'SoulMusic',
              style: TextStyle(fontFamily: 'Nunito'),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: Center(child: screens[currentPage]),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AudioPlayerScreen(),
          BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note),
                title: Text('Songs'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text('Artists'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), title: Text('Search')),
            ],
            backgroundColor: Theme.of(context).primaryColor,
            selectedItemColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Theme.of(context).accentColor,
            currentIndex: currentPage,
            showUnselectedLabels: true,
            onTap: (value) {
              setState(() {
                currentPage = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

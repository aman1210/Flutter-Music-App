import 'package:SoulMusic/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';

import './screens/tab_screen.dart';
import './providers/songs_provider.dart';
import './providers/now_playing_provider.dart';
import './providers/artist_provider.dart';
import './screens/now_playing_screen.dart';
import './providers/auth_provider.dart';
import './screens/artist_detail_screen.dart';
import './screens/auth_screen.dart';
import './screens/liked_screen.dart';
import './screens/playlist_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(create: (ctx) => Songs()),
        ChangeNotifierProvider(create: (ctx) => NowPlaying()),
        ChangeNotifierProvider(create: (ctx) => Artists()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return WillPopScope(
            onWillPop: () async {
              MoveToBackground.moveTaskToBack();
              return false;
            },
            child: MaterialApp(
              title: 'SoulMusic',
              theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.purple,
                accentColor: Colors.amber,
                fontFamily: 'Nunito',
                textTheme: ThemeData().textTheme.copyWith(
                      headline6: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                      ),
                    ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                accentColor: Colors.purple,
              ),
              home: auth.isAuth
                  ? TabScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return AuthScreen();
                      },
                    ),
              routes: {
                NowPlayingScreen.routeName: (ctx) => NowPlayingScreen(),
                ArtistDetailScreen.routeName: (ctx) => ArtistDetailScreen(),
                PlaylistScreen.routeName: (ctx) => PlaylistScreen(),
                LikedScreen.routeName: (ctx) => LikedScreen(),
                SearchScreen.routeName: (ctx) => SearchScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}

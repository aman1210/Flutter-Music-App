import 'package:SoulMusic/providers/auth_provider.dart';
import 'package:SoulMusic/screens/liked_screen.dart';
import 'package:SoulMusic/screens/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assests/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5, color: Colors.grey, offset: Offset(-5, 5)),
                ],
              ),
              width: double.infinity,
              child: Container(
                width: double.infinity,
                color: Colors.white30,
                child: Text(
                  'Hello!',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 40,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              alignment: Alignment.bottomLeft,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(PlaylistScreen.routeName);
                      },
                      icon: Icon(
                        Icons.library_music,
                        color: Colors.blue[500],
                        size: 28,
                      ),
                      label: Text(
                        'Playlist',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    FlatButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(LikedScreen.routeName);
                      },
                      icon: Icon(
                        Icons.favorite,
                        size: 28,
                        color: Colors.red[700],
                      ),
                      label: Text(
                        'Liked',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FlatButton.icon(
              onPressed: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.green,
                size: 23,
              ),
              label: Text(
                'Logout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        elevation: 10,
      ),
    );
  }
}

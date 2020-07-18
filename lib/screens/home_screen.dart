import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../providers/songs_provider.dart';
import '../widgets/song.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Songs>(context, listen: false).fetchAndSetSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          return Consumer<Songs>(
              builder: (context, songData, child) => Swiper(
                    itemCount: songData.songs.length,
                    itemBuilder: (context, index) =>
                        SongShow(songData.songs[index]),
                    index: 0,
                    control: SwiperControl(color: Colors.amber),
                  )

              // GridView.builder(
              //   padding: const EdgeInsets.all(10),
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 1,
              //     childAspectRatio: 1.9,
              //   ),
              //   itemBuilder: (ctx, index) {
              //     return SongShow(
              //       songData.songs[index],
              //     );
              //   },
              //   scrollDirection: Axis.horizontal,
              //   itemCount: songData.songs.length,
              //   shrinkWrap: true,
              // ),
              );
        });
  }
}

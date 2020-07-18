import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Artist {
  String id;
  String artist;
  String artistImage;
  List<String> songs;

  Artist({
    @required this.id,
    @required this.artist,
    @required this.artistImage,
    @required this.songs,
  });
}

class Artists with ChangeNotifier {
  List<Artist> _artists = [];

  List<Artist> get artist {
    return [..._artists];
  }

  Future<void> fetchAndSetArtists() async {
    var url =
        "http://soulmusic-env.eba-rkv4vduy.us-east-2.elasticbeanstalk.com/api/artists";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final extactedArtist = extractedData['artist'];
      final List<Artist> loadedArtist = [];
      extactedArtist.forEach((artist) {
        // print(artist['songs']);
        loadedArtist.add(
          Artist(
            id: artist['_id'],
            artist: artist['artist'],
            artistImage: artist['artistImage'],
            songs: (artist['songs'] as List<dynamic>)
                .map((song) => song.toString())
                .toList(),
          ),
        );
      });
      _artists = loadedArtist;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Artist findById(String id) {
    return _artists.firstWhere((artist) => artist.id == id);
  }

  List<Artist> search(String search) {
    List<Artist> matchedArtist = [];
    _artists.forEach((artist) {
      if (artist.artist.toLowerCase().startsWith(search.toLowerCase())) {
        matchedArtist.add(artist);
      }
    });
    return matchedArtist;
  }
}

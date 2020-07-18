import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String albumArt;
  final int likes;
  final String url;

  Song({
    @required this.id,
    @required this.title,
    @required this.artist,
    @required this.album,
    @required this.albumArt,
    @required this.likes,
    @required this.url,
  });
}

class Songs with ChangeNotifier {
  List<Song> _songs = [];
  List<Song> _playlist = [];
  List<Song> _liked = [];
  List<String> playlistId = [];

  List<Song> get playlist {
    return [..._playlist];
  }

  List<Song> get songs {
    return [..._songs];
  }

  List<Song> get liked {
    return [..._liked];
  }

  Future<void> fetchAndSetSongs() async {
    var url =
        'http://soulmusic-env.eba-rkv4vduy.us-east-2.elasticbeanstalk.com/api/songs';
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final extractedSongs = extractedData['songs'];
      final List<Song> loadedSongs = [];
      extractedSongs.forEach((songData) {
        loadedSongs.add(
          Song(
            id: songData['_id'],
            title: songData['name'],
            artist: songData['artist'],
            album: songData['album'],
            albumArt: songData['albumArt'],
            likes: songData['likes'],
            url: songData['url'],
          ),
        );
      });
      _songs = loadedSongs;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Song findById(String id) {
    return _songs.firstWhere((song) => song.id == id);
  }

  Song findNextSong(String id) {
    int index = _songs.indexWhere((song) => song.id == id);
    if (index != _songs.length - 1) {
      return _songs[index + 1];
    } else {
      return null;
    }
  }

  Song findPreviousSong(String id) {
    int index = _songs.indexWhere((song) => song.id == id);
    if (index != 0) {
      return _songs[index - 1];
    } else {
      return null;
    }
  }

  Future<void> setPlaylist(List<String> playlist) async {
    playlistId = playlist;
    List<Song> loadPlaylist = [];
    playlist.forEach((songId) {
      var song = _songs.firstWhere((song) => song.id == songId);
      loadPlaylist.add(song);
    });
    _playlist = loadPlaylist;
  }

  Future<void> setliked(List<String> playlist) async {
    List<Song> loadLiked = [];
    playlist.forEach((songId) {
      var song = _songs.firstWhere((song) => song.id == songId);
      loadLiked.add(song);
    });
    _liked = loadLiked;
  }

  List<Song> search(String search) {
    List<Song> data = [];
    _songs.forEach((song) {
      if (song.title.toLowerCase().startsWith(search.toLowerCase())) {
        data.add(song);
      }
    });
    return data;
  }
}

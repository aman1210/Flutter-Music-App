import 'dart:async';
import 'dart:convert';

import 'package:SoulMusic/models/HttpExceptions.dart';
import 'package:SoulMusic/providers/songs_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  List<String> liked = [];
  List<String> playlist = [];

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signup(String email, String password) async {
    try {
      final url = "https://soulmusic-backend.herokuapp.com/api/users/signup";
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions(
            responseData['err']['errors']['email']['properties']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  bool addToPlaylist(String songId) {
    if (playlist.contains(songId)) {
      return false;
    }
    playlist.add(songId);
    savePlaylist();
    return true;
  }

  Future<void> savePlaylist() async {
    saveData();
    // print(playlist.toList());
    // final url =
    //     "http://soulmusic-env.eba-rkv4vduy.us-east-2.elasticbeanstalk.com/api/users/playlist";
    // final response = await http.put(url,
    //     body: json.encode(),
    //     headers: {"Authorization": "Bearer $token"});
    // print(response.body);
    // if (response.statusCode < 400) {
    //   final prefs = await SharedPreferences.getInstance();
    //   // print(prefs.get('userData'));
    // }
  }

  bool isLiked(String id) {
    return liked.contains(id);
  }

  void toggleLiked(String id) {
    if (liked.contains(id)) {
      liked.removeWhere((liked) => liked == id);
    } else {
      liked.add(id);
    }
    notifyListeners();
    saveData();
  }

  Future<void> deleteFromPlaylist(String id) async {
    playlist.removeWhere((sId) => sId == id);
    saveData();
  }

  Future<void> deleteFromLiked(Song song) async {
    liked.removeWhere((sId) => sId == song.id);

    notifyListeners();
    saveData();
  }

  Future<void> login(String email, String password) async {
    try {
      final url = "https://soulmusic-backend.herokuapp.com/api/users/login";
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpExceptions(responseData['message']);
      }

      _token = responseData['token'];
      _userId = responseData['userId'];
      _expiryDate = DateTime.now().add(
        Duration(
          hours: responseData['expiresIn'],
        ),
      );
      liked = (responseData['liked'] as List<dynamic>)
          .map((songId) => songId.toString())
          .toList();
      playlist = (responseData['playlist'] as List<dynamic>)
          .map((sId) => sId.toString())
          .toList();
      autoLogout();
      notifyListeners();
      saveData();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData = json.decode(prefs.getString('userData'));
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    liked = (userData['liked'] as List<dynamic>)
        .map((sId) => sId.toString())
        .toList();
    playlist = (userData['playlist'] as List<dynamic>)
        .map((sId) => sId.toString())
        .toList();
    notifyListeners();
    autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final time = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: time),
      logout,
    );
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String(),
      'liked': liked,
      'playlist': playlist,
    });
    prefs.setString('userData', userData);
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:beats/models/ProgressModel.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'dart:math';
import 'RecentsModel.dart';
import 'package:flutter/services.dart';
import 'package:beats/screens/PlayList.dart';


class LocalSongsModel extends ChangeNotifier {
  // Thousands of stuff packed into this ChangeNotifier
  var songs = <Song>[];
  var duplicate = <Song>[]; // Duplicate of songs variable for Search function
  Song currentSong;
  bool playlist = false;
  var playlistSongs = <Song>[];
  MusicFinder player;
  ProgressModel prog;
  var position;
  Recents recents;

  LocalSongsModel() {
    fetchSongs();
  }

  fetchSongs() async {
    songs = await MusicFinder.allSongs();

    if (songs.length == 0) songs = null;
    player = new MusicFinder();
    songs?.forEach((item) {
      duplicate.add(item);
    });

    notifyListeners();
  }

  updateUI() {
    notifyListeners();
  }

  seek(pos) {
    player.seek(pos);
  }

}
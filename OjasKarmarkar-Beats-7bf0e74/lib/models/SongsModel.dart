import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:beats/models/ProgressModel.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'dart:math';
import 'RecentsModel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

enum PlayerState { PLAYING, PAUSED, STOPPED }

class SongsModel extends ChangeNotifier {
  // Thousands of stuff packed into this ChangeNotifier
  var songs = <Song>[];
  var duplicate = <Song>[]; // Duplicate of songs variable for Search function
  Song currentSong;
  bool playlist = false;
  var playlistSongs = <Song>[];
  var currentState;
  MusicFinder player;
  ProgressModel prog;
  var position;
  bool shuffle = false;
  bool repeat = false;
  Random rnd = new Random();
  Recents recents;

  SongsModel(prov, rec) {
    fetchSongs();
    prog = prov;
    recents = rec;
  }

  fetchSongs() async {
    songs = await MusicFinder.allSongs();
    if (songs.length == 0) songs = null;
    player = new MusicFinder();
    initValues();
    player.setPositionHandler((p) {
      prog.setPosition(p.inSeconds);
    });
    songs?.forEach((item) {
      duplicate.add(item);
    });

    notifyListeners();
  }

  updateUI() {
    notifyListeners();
  }

  playURI(var uri1) {
    player.stop();
    for (var song1 in songs) {
      if (song1.uri == uri1) {
        currentSong = song1;
        play();
        break;
      }
    }
  }

  initValues() {
    player.setDurationHandler((d) {
      prog.setDuration(d.inSeconds);
    });

    player.setCompletionHandler(() {
      player.stop();
      if (repeat) {
        current_Song();
      } else if (shuffle) {
        random_Song();
      } else {
        next();
      }
      play();
    });
  }

  seek(pos) {
    player.seek(pos);
  }

  play() {
    var song = currentSong;
    player.play(song.uri, isLocal: true);
    currentState = PlayerState.PLAYING;
    recents.add(song);
    showNotification(song.title, song.artist, true);
    updateUI();
  }

  stop() {
    currentState = PlayerState.STOPPED;
    hideNotification();
    updateUI();
  }

  pause() {
    player?.pause();
    currentState = PlayerState.PAUSED;
    showNotification(currentSong.title, currentSong.artist, false);
    updateUI();
  }

  next() {
    if (playlist) {
      if (currentSong == playlistSongs[playlistSongs.length - 1]) {
        currentSong = playlistSongs[0];
      } else {
        currentSong = playlistSongs[playlistSongs.indexOf(currentSong) + 1];
      }
    } else {
      if (currentSong == songs[songs.length - 1]) {
        currentSong = songs[0];
      } else {
        currentSong = songs[songs.indexOf(currentSong) + 1];
      }
    }

    updateUI();
  }

  previous() {
    if (playlist) {
      if (currentSong == playlistSongs[0]) {
        currentSong = playlistSongs[playlistSongs.length - 1];
      } else {
        currentSong = playlistSongs[playlistSongs.indexOf(currentSong) - 1];
      }
    } else {
      if (currentSong == songs[0]) {
        currentSong = songs[songs.length - 1];
      } else {
        currentSong = songs[songs.indexOf(currentSong) - 1];
      }
    }

    updateUI();
  }

  setRepeat(b) {
    repeat = b;
    notifyListeners();
  }

  setShuffle(b) {
    shuffle = b;
    notifyListeners();
  }

  current_Song() {
    if (playlist) {
      currentSong = playlistSongs[playlistSongs.indexOf(currentSong)];
    } else {
      currentSong = songs[songs.indexOf(currentSong)];
    }
    updateUI();
  }

  random_Song() {
    if (playlist) {
      int max = playlistSongs.length;
      currentSong = playlistSongs[rnd.nextInt(max)];
    } else {
      int max = songs.length;
      currentSong = songs[rnd.nextInt(max)];
    }
    updateUI();
  }

  Future<void> hideNotification() async {
    try {
      await MediaNotification.hideNotification();
    } on PlatformException {}
  }

  Future<void> showNotification(title, author, isPlaying) async {
    try {
      await MediaNotification.showNotification(
          title: title, author: author, isPlaying: isPlaying);
    } on PlatformException {}
  }
}


class Cancion {
  final String respuesta;

  Cancion({this.respuesta,});

  factory Cancion.fromJson(Map<String, dynamic> json) {
    return Cancion(
      respuesta: json['nombreUsuario'],



    );

  }
  String getUserId(){
    return respuesta;
  }
}

Future<Cancion> obtenerPerfil(String email) async {
  Map data = {
    'email': email,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/perfil_android',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Cancion.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
  }
}

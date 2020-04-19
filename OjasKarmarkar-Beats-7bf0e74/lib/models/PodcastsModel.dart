import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:beats/models/ProgressModel.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'RecentsModel.dart';
import 'package:flutter/services.dart';
import 'package:beats/screens/PlayList.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

enum PlayerState { PLAYING, PAUSED, STOPPED }

class PodcastsModel extends ChangeNotifier {
  // Thousands of stuff packed into this ChangeNotifier
  List<Song> podcasts = new List<Song>();
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

  PodcastsModel(prov, rec) {
    fetchSongs();
    prog = prov;
    recents = rec;
  }

  fetchSongs() async {
    ListaCancionesDefault c = await obtenerListaPodcasts();
    List<String> listaNombres = c.getNombresAudio().split('|');
    List<String> listaUrls = c.getUrlsAudio().split('|');

    for(int i = 0; i<listaNombres.length; i++){
      podcasts.add(new Song(1,"", listaNombres[i], "",0,0,listaUrls[i],null));
      String yy = podcasts[i].title;
      debugPrint('data: $yy');
    }
    for(int j=0; j<listaNombres.length;j++){
      String yoy = podcasts[j].title;
      debugPrint('finalote: $yoy');
    }

    if (podcasts.length == 0) podcasts = null;
    player = new MusicFinder();
    initValues();
    player.setPositionHandler((p) {
      prog.setPosition(p.inSeconds);
    });
    podcasts?.forEach((item) {
      duplicate.add(item);
    });

    notifyListeners();
  }

  fetchSongsManual(List<Song> canciones){
    String s = canciones[0].title;
    String so = canciones[1].title;
    debugPrint('manual: $s');
    debugPrint('manual: $so');
    podcasts = canciones;
    s = podcasts[0].title;
    so = podcasts[1].title;
    debugPrint('manual: $s');
    debugPrint('manual: $so');
    if (podcasts.length == 0) podcasts = null;
    player = new MusicFinder();
    initValues();
    player.setPositionHandler((p) {
      prog.setPosition(p.inSeconds);
    });
    s = podcasts[0].title;
    so = podcasts[1].title;
    debugPrint('manual: $s');
    debugPrint('manual: $so');
  }


  updateUI() {
    notifyListeners();
  }

  playURI(var uri1) {
    player.stop();
    for (var song1 in podcasts) {
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

  play() async {
    var song = currentSong;
    player.play(song.uri, isLocal: false);
    currentState = PlayerState.PLAYING;
    recents.add(song);
    showNotification(song.title, song.artist, true);
    updateUI();
  }

  List<Song> getSongs(){
    return podcasts;
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
      if (currentSong == podcasts[podcasts.length - 1]) {
        currentSong = podcasts[0];
      } else {
        currentSong = podcasts[podcasts.indexOf(currentSong) + 1];
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
      if (currentSong == podcasts[0]) {
        currentSong = podcasts[podcasts.length - 1];
      } else {
        currentSong = podcasts[podcasts.indexOf(currentSong) - 1];
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
      currentSong = podcasts[podcasts.indexOf(currentSong)];
    }
    updateUI();
  }

  random_Song() {
    if (playlist) {
      int max = playlistSongs.length;
      currentSong = playlistSongs[rnd.nextInt(max)];
    } else {
      int max = podcasts.length;
      currentSong = podcasts[rnd.nextInt(max)];
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



class ListaCancionesDefault {
  final String nombresAudio;
  final String urlsAudio;


  ListaCancionesDefault({this.nombresAudio, this.urlsAudio});

  factory ListaCancionesDefault.fromJson(Map<String, dynamic> json) {
    return ListaCancionesDefault(
      nombresAudio: json['nombresAudio'],
      urlsAudio: json['urlsAudio'],
    );
  }
  String getNombresAudio(){
    return nombresAudio;
  }
  String getUrlsAudio(){
    return urlsAudio;
  }
}

Future<ListaCancionesDefault> obtenerListaPodcasts() async {
  Map data = {
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/obtener_randomaudios_android',    //todo cambiar url
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return ListaCancionesDefault.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
  }
}

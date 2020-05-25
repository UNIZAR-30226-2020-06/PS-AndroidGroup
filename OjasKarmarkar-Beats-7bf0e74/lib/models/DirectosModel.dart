import 'dart:convert';
import 'dart:math' hide log;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:beats/models/ProgressModel.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'RecentsModel.dart';
import 'package:flutter/services.dart';
import 'package:beats/screens/PlayList.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'Username.dart';

enum PlayerState { PLAYING, PAUSED, STOPPED }

class DirectosModel extends ChangeNotifier {
  // Thousands of stuff packed into this ChangeNotifier
  List<Song> songs = new List<Song>();
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

  String email;
  bool currentLike = false;

  DirectosModel(prov, rec) {
    fetchSongs();
    prog = prov;
    recents = rec;
  }



  fetchSongs() async {
    ListaCancionesDefault c = await obtenerListaCanciones();
    List<String> listaNombres = c.getNombresAudio().split('|');
    List<String> listaUrls = c.getUrlsAudio().split('|');

    for(int i = 0; i<listaNombres.length; i++){
      songs.add(new Song(i,"", listaNombres[i], "",0,0,listaUrls[i],null));   //todo ojito aquí habia un "" en el id
      String yy = songs[i].title;
      debugPrint('data: $yy');
    }
    for(int j=0; j<listaNombres.length;j++){
      String yoy = songs[j].title;
      debugPrint('finalote: $yoy');
    }

    if (songs.length == 0) songs = null;
    player = new MusicFinder();
    songs?.forEach((item) {
      duplicate.add(item);
    });

    notifyListeners();
  }

  fetchSongsManual(List<Song> canciones){
    songs = canciones;
    if (songs.length == 0) songs = null;
    player = new MusicFinder();
    initValues();
    player.setPositionHandler((p) {
      prog.setPosition(p.inSeconds);
    });

  }

  Song devuelveCancion(String nombreCancion){
    for(Song s in songs){
      if(s.title == nombreCancion){
        return s;
      }
    }
    return null;
  }


  updateUI() {
    //await likeado(email);
    notifyListeners();
  }

  playURI(var uri1) {
    if(currentState == PlayerState.PLAYING){
      log("parar el intento de arrancar");
      stop();
    }
    for (var song1 in songs) {
      if (song1.uri == uri1) {
        log("arrancar: $currentState");
        currentSong = song1;
        String directoQueSeArranca = song1.title; String uri = song1.uri;
        log("lanzo: $directoQueSeArranca");
        log("uri: $uri");
        FlutterRadio.play(url: song1.uri);
        currentState=PlayerState.PLAYING;
        log("arrancado: $currentState");
        break;
      }
    }
    updateUI();
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
    FlutterRadio.play(url: song.uri);
    currentState = PlayerState.PLAYING;
    updateUI();
  }

  List<Song> getSongs(){
    return songs;
  }

  stop() {
    currentState = PlayerState.STOPPED;
    FlutterRadio.stop();
    hideNotification();
    updateUI();
  }

  pause() {
    FlutterRadio.pause(url: currentSong.uri);
    currentState = PlayerState.PAUSED;
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


  void Like(String email) async {
    Map data = {
      'email' : email,
      'titulo' : this.currentSong.title,
      'tipo' : "audio",
      'url' : this.currentSong.uri,
    };

    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/like_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      log("se ha cambiado de como estaba");
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }


  Future<bool> likeado(String email) async{
    Map data = {
      'email' : email,
      'titulo' : this.currentSong.title,
      'tipo' : "audio",
      'url' : this.currentSong.uri,
    };

    final http.Response response = await http.post(
      'http://34.69.44.48:8080/Espotify/tiene_like_android',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      respuesta r = respuesta.fromJson(json.decode(response.body));
      String s = r.getlikeado();
      log("likeado: $s");
      if(r.getlikeado() == "false") {
        currentLike = false;
      } else if (r.getlikeado() == "true") {
        currentLike = true;
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Fallo al enviar petición');
    }
  }

  void setEmail(String emailVal) {
    email=emailVal;
  }

}

class respuesta {
  final String likeado;

  respuesta({this.likeado});

  factory respuesta.fromJson(Map<String, dynamic> json) {
    return respuesta(
      likeado: json['likeado'],
    );
  }
  String getlikeado(){
    return likeado;
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

Future<ListaCancionesDefault> obtenerListaCanciones() async {
  Map data = {
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/obtener_randomaudios_android',
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

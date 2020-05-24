import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:beats/models/Username.dart';
import 'package:beats/screens/Player.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:provider/provider.dart';
import 'package:beats/models/SongsModel.dart';
import 'package:beats/models/BookmarkModel.dart';
import '../custom_icons.dart';
import 'MusicLibrary.dart';
import 'package:beats/Animations/transitions.dart';
import 'package:http/http.dart' as http;

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  SongsModel model;
  Username username;
  bool isPlayed = false;
  Canciones canciones;

  List<Song> songs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    username = Provider.of<Username>(context);
    model = Provider.of<SongsModel>(context);
    initDataFavoritos();

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SongsModel>(
      builder: (context, bm, _) => WillPopScope(
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Stack(
            children: <Widget>[
              (bm.songs == null)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : (bm.songs.length == 0 || bm.songs.length == null || canciones == null || bm.songs[0].title =="")
                      ? Center(
                          child: Text(
                          "No hay favoritos",
                          style: Theme.of(context).textTheme.display1,
                        ))
                      : Container(
                          height: 220,
                          width: width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                Text("Favoritos",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30.0)),
                              ],
                            ),
                          ),
                          // Add box decoration
                          decoration: BoxDecoration(
                            // Box decoration takes a gradient
                            gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              // Add one stop for each color. Stops should increase from 0 to 1
                              stops: [0.1, 0.5, 0.7, 0.9],
                              colors: [
                                Colors.orange,
                                Colors.orangeAccent,
                                Colors.orange,
                                Colors.orangeAccent,
                              ],
                            ),
                          )),
              (bm.songs.length == 0 || bm.songs.length == null || canciones == null || bm.songs[0].title == "")
              ? Text("")

             : Padding(
                padding: EdgeInsets.only(top: 220),
                child: ListView.builder(
                  itemCount: bm.songs.length,
                  itemBuilder: (context, pos) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                      child: ListTile(
                        onTap: () {
                          model.player.stop();
                          model.playlist = true;
                          model.playlistSongs = bm.songs;
                          model.currentSong = bm.songs[pos];

                          model.play();
                        },
                        leading: CircleAvatar(backgroundColor: Colors.orange,child: getImage(bm, pos)),
                        title: Text(
                          bm.songs[pos].title,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.display1.color),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            bm.songs[pos].artist,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 12,
                                color:
                                    Theme.of(context).textTheme.display1.color),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: showStatus(model, context),
              )
            ],

          ),
        ),
        onWillPop: () {},
      ),
    );
  }

  void initDataFavoritos() async {
    Canciones l = await obtenerFavoritos(username.email);
    var listaNombres = l.getNombresAudio().split('|');
    var listaUrls = l.getUrlsAudio().split('|');
    var listaIds = l.listaIds.split('|');
    List<Song> listaCanciones = new List<Song>();
    for(int i = 0; i<listaNombres.length; i++){
      listaCanciones.add(new Song(int.parse(listaIds[i]),"", listaNombres[i], "",0,0,listaUrls[i],null));
    }
    songs = listaCanciones;
    model.fetchSongsManual(songs);
    canciones = l;
    setState(() {});

  }

  getImage(bm, pos) {
    if (bm.songs[pos].albumArt != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child:
              Image.file(File.fromUri(Uri.parse(bm.songs[pos].albumArt))));
    } else {
      return Icon(Icons.music_note, color: Colors.white,);
    }
  }

  showStatus(model, context) {
    if (model.currentSong != null) {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).textTheme.display1.color,
              ),
            )),
        height: height * 0.06,
        width: width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (context, pos) {
            return GestureDetector(
              onTap: () {
                username.esCancion = true;
                Navigator.push(context, Scale(page: PlayBackPage()));
              },
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        color: Theme.of(context).textTheme.display1.color,
                        icon: Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          username.esCancion = true;
                          Navigator.push(context, Scale(page: PlayBackPage()));
                        },
                      ),
                      Container(
                        width: width * 0.75,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            model.currentSong.title,
                            style: Theme.of(context).textTheme.display2,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: IconButton(
                          icon: model.currentState == PlayerState.PAUSED ||
                                  model.currentState == PlayerState.STOPPED
                              ? Icon(
                                  CustomIcons.play,
                                  color: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .color,
                                  size: 20.0,
                                )
                              : Icon(
                                  CustomIcons.pause,
                                  color: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .color,
                                  size: 20.0,
                                ),
                          onPressed: () {
                            if (model.currentState == PlayerState.PAUSED ||
                                model.currentState == PlayerState.STOPPED) {
                              model.play();
                            } else {
                              model.pause();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {}
  }
}
class Canciones {
  final String respuesta;
  final String nombresAudio;
  final String urlsAudio;
  final String genero;
  final String autor;
  final String listaIds;
  Canciones({this.respuesta, this.nombresAudio,this.urlsAudio, this.genero, this.autor, this.listaIds});

  factory Canciones.fromJson(Map<String, dynamic> json) {
    return Canciones(
      nombresAudio: json['nombresAudio'],
      urlsAudio: json['urlsAudio'],
      listaIds: json['idsAudio'],

    );

  }
  String getUserId(){
    return respuesta;
  }
  String getNombresAudio(){
    return nombresAudio;
  }
  String getUrlsAudio(){
    return urlsAudio;
  }
}
Future<Canciones> obtenerFavoritos(String email) async {
  Map data = {
    'email': email,
  };
  final http.Response response = await http.post(
    'http://34.69.44.48:8080/Espotify/obtener_favoritos_android',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),

  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Canciones.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo al enviar petición');
  }
}